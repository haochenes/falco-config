# Collect real Falco logs per IDPS case (IDIADA compliance)
# Run from project root: .\test\test_cases\collect_logs_host.ps1
# Prereq: Falco running in container, json_output=true in falco.yaml
# No truncate - uses line-count extraction to preserve falco.log (avoids triggering rules)
# Outputs: IDIADA_FALCO_LOGS/*.log (with headers), IDIADA_FALCO_LOGS_JSON/*.json (valid JSON)

# New path in mounted volume; fallback to legacy path
$FALCO_LOG = "/var/log/falco/falco.log"
$FALCO_LOG_LEGACY = "/var/log/falco.log"

$idpsDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outDir = Join-Path $idpsDir "IDIADA_FALCO_LOGS"
$outDirJson = Join-Path $idpsDir "IDIADA_FALCO_LOGS_JSON"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $outDirJson | Out-Null

# Falco must run with json_output=true. Log path: $FALCO_LOG (in mounted falco-logs)
$cases = Get-ChildItem -Path $idpsDir -Filter "SYS-*.sh" | Where-Object { 
    $_.Name -notmatch "run_all|collect_" 
} | Sort-Object Name

foreach ($f in $cases) {
    $caseId = $f.BaseName
    $logFile = Join-Path $outDir "$caseId.log"
    $jsonFile = Join-Path $outDirJson "$caseId.json"
    $collectedAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    Write-Host ">>> $caseId"
    
    # Line-count extraction (no truncate - preserves falco.log, avoids triggering rules)
    $lineCountBefore = 0
    $logPath = $FALCO_LOG
    $lineCountStr = docker exec falco-test-ubuntu bash -c "wc -l < $FALCO_LOG 2>/dev/null" 2>$null
    if ($null -eq $lineCountStr -or $lineCountStr -eq "") {
        $lineCountStr = docker exec falco-test-ubuntu bash -c "wc -l < $FALCO_LOG_LEGACY 2>/dev/null" 2>$null
        $logPath = $FALCO_LOG_LEGACY
    }
    if ($lineCountStr) { [int]::TryParse($lineCountStr.Trim(), [ref]$lineCountBefore) | Out-Null }
    Start-Sleep -Milliseconds 300
    
    # SYS-LOG-002 needs --execute
    $extraArgs = ""
    if ($caseId -eq "SYS-LOG-002") { $extraArgs = " --execute" }
    
    docker exec falco-test-ubuntu bash -c "cd /opt/falco-test/test_cases && bash $($f.Name)$extraArgs" 2>$null | Out-Null
    Start-Sleep -Seconds 2
    
    # Extract only new lines since test started
    $logContent = docker exec falco-test-ubuntu bash -c "tail -n +$($lineCountBefore + 1) $logPath 2>/dev/null" 2>$null
    $rawLines = @()
    if ($logContent -and $logContent.Trim()) {
        $rawLines = ($logContent -split "`n") | Where-Object { $_.Trim().Length -gt 0 }
    }
    
    # Build .log file (header + body)
    $header = @"
# IDIADA Compliance - Real Falco Detection Log
# Case: $caseId
# Collected: $collectedAt
# Test script: $($f.Name)
# ----------------------------------------

"@
    $body = if ($rawLines.Count -gt 0) { $rawLines -join "`n" } else { "# (No Falco detection for this case)" }
    Set-Content -Path $logFile -Value ($header + $body) -Encoding UTF8
    
    # Build .json file - VALID JSON only
    $events = @()
    foreach ($line in $rawLines) {
        try {
            $obj = $line | ConvertFrom-Json -ErrorAction Stop
            if ($obj) { $events += $obj }
        } catch {
            # Not JSON - wrap as raw message
            $events += [PSCustomObject]@{ output = $line; _raw = $true }
        }
    }
    $jsonResult = @{
        case_id = $caseId
        collected = $collectedAt
        test_script = $f.Name
        event_count = $events.Count
        events = $events
    }
    $jsonStr = $jsonResult | ConvertTo-Json -Depth 15
    Set-Content -Path $jsonFile -Value $jsonStr -Encoding UTF8
    
    Write-Host "    -> $logFile ($($events.Count) events)"
    Write-Host "    -> $jsonFile (JSON)"
}
Write-Host "`nDone. Output: $outDir, $outDirJson"