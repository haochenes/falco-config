/*-
 * Copyright (c) 2010,2021,2024 Joseph Koshy
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS `AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * WARNING: GENERATED FILE.  DO NOT MODIFY.
 *
 *  GENERATED FROM: $Id: elfdefinitions.m4 3984 2022-05-06 11:22:42Z jkoshy $
 *  GENERATED FROM: $Id: elfconstants.m4 4053 2024-11-25 13:42:22Z jkoshy $
 */

/*
 * These definitions are based on:
 * - The public specification of the ELF format as defined in the
 *   October 2009 draft of System V ABI.
 *   See: http://www.sco.com/developers/gabi/latest/ch4.intro.html
 * - The May 1998 (version 1.5) draft of "The ELF-64 object format".
 * - Processor-specific ELF ABI definitions for sparc, i386, amd64, mips,
 *   ia64, powerpc, and RISC-V processors.
 * - The "Linkers and Libraries Guide", from Sun Microsystems.
 */

#ifndef _SYS_ELFDEFINITIONS_H_
#define _SYS_ELFDEFINITIONS_H_

/*
 * Types of capabilities.
 */

#define CA_SUNW_NULL	0 /* ignored */
#define CA_SUNW_HW_1	1 /* hardware capability */
#define CA_SUNW_SW_1	2 /* software capability */

/*
 * Flags used with dynamic linking entries.
 */

#define DF_ORIGIN	0x1 /* object being loaded may refer to $ORIGIN */
#define DF_SYMBOLIC	0x2 /* search library for references before executable */
#define DF_TEXTREL	0x4 /* relocation entries may modify text segment */
#define DF_BIND_NOW	0x8 /* process relocation entries at load time */
#define DF_STATIC_TLS	0x10 /* uses static thread-local storage */
#define DF_1_BIND_NOW	0x1 /* process relocation entries at load time */
#define DF_1_GLOBAL	0x2 /* unused */
#define DF_1_GROUP	0x4 /* object is a member of a group */
#define DF_1_NODELETE	0x8 /* object cannot be deleted from a process */
#define DF_1_LOADFLTR	0x10 /* immediate load filtees */
#define DF_1_INITFIRST	0x20 /* initialize object first */
#define DF_1_NOOPEN	0x40 /* disallow dlopen() */
#define DF_1_ORIGIN	0x80 /* object being loaded may refer to $ORIGIN */
#define DF_1_DIRECT	0x100 /* direct bindings enabled */
#define DF_1_INTERPOSE	0x400 /* object is interposer */
#define DF_1_NODEFLIB	0x800 /* ignore default library search path */
#define DF_1_NODUMP	0x1000 /* disallow dldump() */
#define DF_1_CONFALT	0x2000 /* object is a configuration alternative */
#define DF_1_ENDFILTEE	0x4000 /* filtee terminates filter search */
#define DF_1_DISPRELDNE	0x8000 /* displacement relocation done */
#define DF_1_DISPRELPND	0x10000 /* displacement relocation pending */

/*
 * Dynamic linking entry types.
 */

#define DT_NULL		0 /* end of array */
#define DT_NEEDED	1 /* names a needed library */
#define DT_PLTRELSZ	2 /* size in bytes of associated relocation entries */
#define DT_PLTGOT	3 /* address associated with the procedure linkage table */
#define DT_HASH		4 /* address of the symbol hash table */
#define DT_STRTAB	5 /* address of the string table */
#define DT_SYMTAB	6 /* address of the symbol table */
#define DT_RELA		7 /* address of the relocation table */
#define DT_RELASZ	8 /* size of the DT_RELA table */
#define DT_RELAENT	9 /* size of each DT_RELA entry */
#define DT_STRSZ	10 /* size of the string table */
#define DT_SYMENT	11 /* size of a symbol table entry */
#define DT_INIT		12 /* address of the initialization function */
#define DT_FINI		13 /* address of the finalization function */
#define DT_SONAME	14 /* names the shared object */
#define DT_RPATH	15 /* runtime library search path */
#define DT_SYMBOLIC	16 /* alter symbol resolution algorithm */
#define DT_REL		17 /* address of the DT_REL table */
#define DT_RELSZ	18 /* size of the DT_REL table */
#define DT_RELENT	19 /* size of each DT_REL entry */
#define DT_PLTREL	20 /* type of relocation entry in the procedure linkage table */
#define DT_DEBUG	21 /* used for debugging */
#define DT_TEXTREL	22 /* text segment may be written to during relocation */
#define DT_JMPREL	23 /* address of relocation entries associated with the procedure linkage table */
#define DT_BIND_NOW	24 /* bind symbols at loading time */
#define DT_INIT_ARRAY	25 /* pointers to initialization functions */
#define DT_FINI_ARRAY	26 /* pointers to termination functions */
#define DT_INIT_ARRAYSZ	27 /* size of the DT_INIT_ARRAY */
#define DT_FINI_ARRAYSZ	28 /* size of the DT_FINI_ARRAY */
#define DT_RUNPATH	29 /* index of library search path string */
#define DT_FLAGS	30 /* flags specific to the object being loaded */
#define DT_ENCODING	32 /* standard semantics */
#define DT_PREINIT_ARRAY 32 /* pointers to pre-initialization functions */
#define DT_PREINIT_ARRAYSZ 33 /* size of pre-initialization array */
#define DT_MAXPOSTAGS	34 /* the number of positive tags */
#define DT_LOOS		0x6000000D /* start of OS-specific types */
#define DT_SUNW_AUXILIARY 0x6000000D /* offset of string naming auxiliary filtees */
#define DT_SUNW_RTLDINF	0x6000000E /* rtld internal use */
#define DT_SUNW_FILTER	0x6000000F /* offset of string naming standard filtees */
#define DT_SUNW_CAP	0x60000010 /* address of hardware capabilities section */
#define DT_SUNW_ASLR	0x60000023 /* Address Space Layout Randomization flag */
#define DT_HIOS		0x6FFFF000 /* end of OS-specific types */
#define DT_VALRNGLO	0x6FFFFD00 /* start of range using the d_val field */
#define DT_GNU_PRELINKED 0x6FFFFDF5 /* prelinking timestamp */
#define DT_GNU_CONFLICTSZ 0x6FFFFDF6 /* size of conflict section */
#define DT_GNU_LIBLISTSZ 0x6FFFFDF7 /* size of library list */
#define DT_CHECKSUM	0x6FFFFDF8 /* checksum for the object */
#define DT_PLTPADSZ	0x6FFFFDF9 /* size of PLT padding */
#define DT_MOVEENT	0x6FFFFDFA /* size of DT_MOVETAB entries */
#define DT_MOVESZ	0x6FFFFDFB /* total size of the MOVETAB table */
#define DT_FEATURE	0x6FFFFDFC /* feature values */
#define DT_POSFLAG_1	0x6FFFFDFD /* dynamic position flags */
#define DT_SYMINSZ	0x6FFFFDFE /* size of the DT_SYMINFO table */
#define DT_SYMINENT	0x6FFFFDFF /* size of a DT_SYMINFO entry */
#define DT_VALRNGHI	0x6FFFFDFF /* end of range using the d_val field */
#define DT_ADDRRNGLO	0x6FFFFE00 /* start of range using the d_ptr field */
#define DT_GNU_HASH	0x6FFFFEF5 /* GNU style hash tables */
#define DT_TLSDESC_PLT	0x6FFFFEF6 /* location of PLT entry for TLS descriptor resolver calls */
#define DT_TLSDESC_GOT	0x6FFFFEF7 /* location of GOT entry used by TLS descriptor resolver PLT entry */
#define DT_GNU_CONFLICT	0x6FFFFEF8 /* address of conflict section */
#define DT_GNU_LIBLIST	0x6FFFFEF9 /* address of conflict section */
#define DT_CONFIG	0x6FFFFEFA /* configuration file */
#define DT_DEPAUDIT	0x6FFFFEFB /* string defining audit libraries */
#define DT_AUDIT	0x6FFFFEFC /* string defining audit libraries */
#define DT_PLTPAD	0x6FFFFEFD /* PLT padding */
#define DT_MOVETAB	0x6FFFFEFE /* address of a move table */
#define DT_SYMINFO	0x6FFFFEFF /* address of the symbol information table */
#define DT_ADDRRNGHI	0x6FFFFEFF /* end of range using the d_ptr field */
#define DT_VERSYM	0x6FFFFFF0 /* address of the version section */
#define DT_RELACOUNT	0x6FFFFFF9 /* count of RELA relocations */
#define DT_RELCOUNT	0x6FFFFFFA /* count of REL relocations */
#define DT_FLAGS_1	0x6FFFFFFB /* flag values */
#define DT_VERDEF	0x6FFFFFFC /* address of the version definition segment */
#define DT_VERDEFNUM	0x6FFFFFFD /* the number of version definition entries */
#define DT_VERNEED	0x6FFFFFFE /* address of section with needed versions */
#define DT_VERNEEDNUM	0x6FFFFFFF /* the number of version needed entries */
#define DT_LOPROC	0x70000000 /* start of processor-specific types */
#define DT_ARM_SYMTABSZ	0x70000001 /* number of entries in the dynamic symbol table */
#define DT_SPARC_REGISTER 0x70000001 /* index of an STT_SPARC_REGISTER symbol */
#define DT_ARM_PREEMPTMAP 0x70000002 /* address of the preemption map */
#define DT_MIPS_RLD_VERSION 0x70000001 /* version ID for runtime linker interface */
#define DT_MIPS_TIME_STAMP 0x70000002 /* timestamp */
#define DT_MIPS_ICHECKSUM 0x70000003 /* checksum of all external strings and common sizes */
#define DT_MIPS_IVERSION 0x70000004 /* string table index of a version string */
#define DT_MIPS_FLAGS	0x70000005 /* MIPS-specific flags */
#define DT_MIPS_BASE_ADDRESS 0x70000006 /* base address for the executable/DSO */
#define DT_MIPS_CONFLICT 0x70000008 /* address of .conflict section */
#define DT_MIPS_LIBLIST	0x70000009 /* address of .liblist section */
#define DT_MIPS_LOCAL_GOTNO 0x7000000A /* number of local GOT entries */
#define DT_MIPS_CONFLICTNO 0x7000000B /* number of entries in the .conflict section */
#define DT_MIPS_LIBLISTNO 0x70000010 /* number of entries in the .liblist section */
#define DT_MIPS_SYMTABNO 0x70000011 /* number of entries in the .dynsym section */
#define DT_MIPS_UNREFEXTNO 0x70000012 /* index of first external dynamic symbol not referenced locally */
#define DT_MIPS_GOTSYM	0x70000013 /* index of first dynamic symbol corresponds to a GOT entry */
#define DT_MIPS_HIPAGENO 0x70000014 /* number of page table entries in GOT */
#define DT_MIPS_RLD_MAP	0x70000016 /* address of runtime linker map */
#define DT_MIPS_DELTA_CLASS 0x70000017 /* Delta C++ class definition */
#define DT_MIPS_DELTA_CLASS_NO 0x70000018 /* number of entries in DT_MIPS_DELTA_CLASS */
#define DT_MIPS_DELTA_INSTANCE 0x70000019 /* Delta C++ class instances */
#define DT_MIPS_DELTA_INSTANCE_NO 0x7000001A /* number of entries in DT_MIPS_DELTA_INSTANCE */
#define DT_MIPS_DELTA_RELOC 0x7000001B /* Delta relocations */
#define DT_MIPS_DELTA_RELOC_NO 0x7000001C /* number of entries in DT_MIPS_DELTA_RELOC */
#define DT_MIPS_DELTA_SYM 0x7000001D /* Delta symbols referred by Delta relocations */
#define DT_MIPS_DELTA_SYM_NO 0x7000001E /* number of entries in DT_MIPS_DELTA_SYM */
#define DT_MIPS_DELTA_CLASSSYM 0x70000020 /* Delta symbols for class declarations */
#define DT_MIPS_DELTA_CLASSSYM_NO 0x70000021 /* number of entries in DT_MIPS_DELTA_CLASSSYM */
#define DT_MIPS_CXX_FLAGS 0x70000022 /* C++ flavor flags */
#define DT_MIPS_PIXIE_INIT 0x70000023 /* address of an initialization routine created by pixie */
#define DT_MIPS_SYMBOL_LIB 0x70000024 /* address of .MIPS.symlib section */
#define DT_MIPS_LOCALPAGE_GOTIDX 0x70000025 /* GOT index of first page table entry for a segment */
#define DT_MIPS_LOCAL_GOTIDX 0x70000026 /* GOT index of first page table entry for a local symbol */
#define DT_MIPS_HIDDEN_GOTIDX 0x70000027 /* GOT index of first page table entry for a hidden symbol */
#define DT_MIPS_PROTECTED_GOTIDX 0x70000028 /* GOT index of first page table entry for a protected symbol */
#define DT_MIPS_OPTIONS	0x70000029 /* address of .MIPS.options section */
#define DT_MIPS_INTERFACE 0x7000002A /* address of .MIPS.interface section */
#define DT_MIPS_DYNSTR_ALIGN 0x7000002B /* ??? */
#define DT_MIPS_INTERFACE_SIZE 0x7000002C /* size of .MIPS.interface section */
#define DT_MIPS_RLD_TEXT_RESOLVE_ADDR 0x7000002D /* address of _rld_text_resolve in GOT */
#define DT_MIPS_PERF_SUFFIX 0x7000002E /* default suffix of DSO to be appended by dlopen */
#define DT_MIPS_COMPACT_SIZE 0x7000002F /* size of a ucode compact relocation record (o32) */
#define DT_MIPS_GP_VALUE 0x70000030 /* GP value of a specified GP relative range */
#define DT_MIPS_AUX_DYNAMIC 0x70000031 /* address of an auxiliary dynamic table */
#define DT_MIPS_PLTGOT	0x70000032 /* address of the PLTGOT */
#define DT_MIPS_RLD_OBJ_UPDATE 0x70000033 /* object list update callback */
#define DT_MIPS_RWPLT	0x70000034 /* address of a writable PLT */
#define DT_PPC_GOT	0x70000000 /* value of _GLOBAL_OFFSET_TABLE_ */
#define DT_PPC_TLSOPT	0x70000001 /* TLS descriptor should be optimized */
#define DT_PPC64_GLINK	0x70000000 /* address of .glink section */
#define DT_PPC64_OPD	0x70000001 /* address of .opd section */
#define DT_PPC64_OPDSZ	0x70000002 /* size of .opd section */
#define DT_PPC64_TLSOPT	0x70000003 /* TLS descriptor should be optimized */
#define DT_AUXILIARY	0x7FFFFFFD /* offset of string naming auxiliary filtees */
#define DT_USED		0x7FFFFFFE /* ignored */
#define DT_FILTER	0x7FFFFFFF /* index of string naming filtees */
#define DT_HIPROC	0x7FFFFFFF /* end of processor-specific types */


/* Aliases for dynamic linking entry symbols. */

#define DT_DEPRECATED_SPARC_REGISTER DT_SPARC_REGISTER


/*
 * Flags used in the executable header (field: e_flags).
 */

#define EF_ARM_RELEXEC	0x00000001U /* dynamic segment describes only how to relocate segments */
#define EF_ARM_HASENTRY	0x00000002U /* e_entry contains a program entry point */
#define EF_ARM_SYMSARESORTED 0x00000004U /* subsection of symbol table is sorted by symbol value */
#define EF_ARM_DYNSYMSUSESEGIDX 0x00000008U /* dynamic symbol st_shndx = containing segment index + 1 */
#define EF_ARM_MAPSYMSFIRST 0x00000010U /* mapping symbols precede other local symbols in symtab */
#define EF_ARM_BE8	0x00800000U /* file contains BE-8 code */
#define EF_ARM_LE8	0x00400000U /* file contains LE-8 code */
#define EF_ARM_EABIMASK	0xFF000000U /* mask for ARM EABI version number (0 denotes GNU or unknown) */
#define EF_ARM_EABI_UNKNOWN 0x00000000U /* Unknown or GNU ARM EABI version number */
#define EF_ARM_EABI_VER1 0x01000000U /* ARM EABI version 1 */
#define EF_ARM_EABI_VER2 0x02000000U /* ARM EABI version 2 */
#define EF_ARM_EABI_VER3 0x03000000U /* ARM EABI version 3 */
#define EF_ARM_EABI_VER4 0x04000000U /* ARM EABI version 4 */
#define EF_ARM_EABI_VER5 0x05000000U /* ARM EABI version 5 */
#define EF_ARM_INTERWORK 0x00000004U /* GNU EABI extension */
#define EF_ARM_APCS_26	0x00000008U /* GNU EABI extension */
#define EF_ARM_APCS_FLOAT 0x00000010U /* GNU EABI extension */
#define EF_ARM_PIC	0x00000020U /* GNU EABI extension */
#define EF_ARM_ALIGN8	0x00000040U /* GNU EABI extension */
#define EF_ARM_NEW_ABI	0x00000080U /* GNU EABI extension */
#define EF_ARM_OLD_ABI	0x00000100U /* GNU EABI extension */
#define EF_ARM_SOFT_FLOAT 0x00000200U /* GNU EABI extension */
#define EF_ARM_VFP_FLOAT 0x00000400U /* GNU EABI extension */
#define EF_ARM_MAVERICK_FLOAT 0x00000800U /* GNU EABI extension */
#define EF_LOONGARCH_ABI_SOFT_FLOAT 0x00000001U /* LoongArch software floating point emulation */
#define EF_LOONGARCH_ABI_SINGLE_FLOAT 0x00000002U /* LoongArch 32-bit floating point registers */
#define EF_LOONGARCH_ABI_DOUBLE_FLOAT 0x00000003U /* LoongArch 64-bit floating point registers */
#define EF_LOONGARCH_ABI_MODIFIER_MASK 0x00000007U /* LoongArch floating point modifier mask */
#define EF_LOONGARCH_OBJABI_V0 0x00000000U /* LoongArch object file ABI version 0 */
#define EF_LOONGARCH_OBJABI_V1 0x00000040U /* LoongArch object file ABI version 1 */
#define EF_LOONGARCH_OBJABI_MASK 0x000000C0U /* LoongArch object file ABI version mask */
#define EF_MIPS_NOREORDER 0x00000001U /* at least one .noreorder directive appeared in the source */
#define EF_MIPS_PIC	0x00000002U /* file contains position independent code */
#define EF_MIPS_CPIC	0x00000004U /* file code uses standard conventions for calling PIC */
#define EF_MIPS_UCODE	0x00000010U /* file contains UCODE (obsolete) */
#define EF_MIPS_ABI	0x00007000U /* Application binary interface */
#define EF_MIPS_ABI2	0x00000020U /* file follows MIPS III 32-bit ABI */
#define EF_MIPS_OPTIONS_FIRST 0x00000080U /* ld(1) should process .MIPS.options section first */
#define EF_MIPS_ARCH_ASE 0x0F000000U /* file uses application-specific architectural extensions */
#define EF_MIPS_ARCH_ASE_MDMX 0x08000000U /* file uses MDMX multimedia extensions */
#define EF_MIPS_ARCH_ASE_M16 0x04000000U /* file uses MIPS-16 ISA extensions */
#define EF_MIPS_ARCH_ASE_MICROMIPS 0x02000000U /* MicroMIPS architecture */
#define EF_MIPS_ARCH	0xF0000000U /* 4-bit MIPS architecture field */
#define EF_MIPS_ARCH_1	0x00000000U /* MIPS I instruction set */
#define EF_MIPS_ARCH_2	0x10000000U /* MIPS II instruction set */
#define EF_MIPS_ARCH_3	0x20000000U /* MIPS III instruction set */
#define EF_MIPS_ARCH_4	0x30000000U /* MIPS IV instruction set */
#define EF_MIPS_ARCH_5	0x40000000U /* Never introduced */
#define EF_MIPS_ARCH_32	0x50000000U /* Mips32 Revision 1 */
#define EF_MIPS_ARCH_64	0x60000000U /* Mips64 Revision 1 */
#define EF_MIPS_ARCH_32R2 0x70000000U /* Mips32 Revision 2 */
#define EF_MIPS_ARCH_64R2 0x80000000U /* Mips64 Revision 2 */
#define EF_PPC_EMB	0x80000000U /* Embedded PowerPC flag */
#define EF_PPC_RELOCATABLE 0x00010000U /* -mrelocatable flag */
#define EF_PPC_RELOCATABLE_LIB 0x00008000U /* -mrelocatable-lib flag */
#define EF_RISCV_RVC	0x00000001U /* Compressed instruction extension */
#define EF_RISCV_FLOAT_ABI_MASK 0x00000006U /* Floating point ABI */
#define EF_RISCV_FLOAT_ABI_SOFT 0x00000000U /* Software emulated floating point */
#define EF_RISCV_FLOAT_ABI_SINGLE 0x00000002U /* Single precision floating point */
#define EF_RISCV_FLOAT_ABI_DOUBLE 0x00000004U /* Double precision floating point */
#define EF_RISCV_FLOAT_ABI_QUAD 0x00000006U /* Quad precision floating point */
#define EF_RISCV_RVE	0x00000008U /* Compressed instruction ABI */
#define EF_RISCV_TSO	0x00000010U /* RVTSO memory consistency model */
#define EF_SPARC_EXT_MASK 0x00FFFF00U /* Vendor Extension mask */
#define EF_SPARC_32PLUS	0x00000100U /* Generic V8+ features */
#define EF_SPARC_SUN_US1 0x00000200U /* Sun UltraSPARCTM 1 Extensions */
#define EF_SPARC_HAL_R1	0x00000400U /* HAL R1 Extensions */
#define EF_SPARC_SUN_US3 0x00000800U /* Sun UltraSPARC 3 Extensions */
#define EF_SPARCV9_MM	0x00000003U /* Mask for Memory Model */
#define EF_SPARCV9_TSO	0x00000000U /* Total Store Ordering */
#define EF_SPARCV9_PSO	0x00000001U /* Partial Store Ordering */
#define EF_SPARCV9_RMO	0x00000002U /* Relaxed Memory Ordering */


/*
 * Offsets in the ei_ident[] field of an ELF executable header.
 */

#define EI_MAG0		0 /* magic number */
#define EI_MAG1		1 /* magic number */
#define EI_MAG2		2 /* magic number */
#define EI_MAG3		3 /* magic number */
#define EI_CLASS	4 /* file class */
#define EI_DATA		5 /* data encoding */
#define EI_VERSION	6 /* file version */
#define EI_OSABI	7 /* OS ABI kind */
#define EI_ABIVERSION	8 /* OS ABI version */
#define EI_PAD		9 /* padding start */
#define EI_NIDENT	16 /* total size */


/*
 * The ELF class of an object.
 */

#define ELFCLASSNONE	0U /* Unknown ELF class */
#define ELFCLASS32	1U /* 32 bit objects */
#define ELFCLASS64	2U /* 64 bit objects */


/*
 * Endianness of data in an ELF object.
 */

#define ELFDATANONE	0U /* Unknown data endianness */
#define ELFDATA2LSB	1U /* little endian */
#define ELFDATA2MSB	2U /* big endian */


/*
 * The magic numbers used in the initial four bytes of an ELF object.
 *
 * These numbers are: 0x7F, 'E', 'L' and 'F'.
 */

#define ELFMAG0		0x7FU
#define ELFMAG1		0x45U
#define ELFMAG2		0x4CU
#define ELFMAG3		0x46U

/* Additional magic-related constants. */

#define ELFMAG		"\177ELF"
#define SELFMAG		4


/*
 * ELF OS ABI field.
 */

#define ELFOSABI_NONE	0U /* No extensions or unspecified */
#define ELFOSABI_SYSV	0U /* SYSV */
#define ELFOSABI_HPUX	1U /* Hewlett-Packard HP-UX */
#define ELFOSABI_NETBSD	2U /* NetBSD */
#define ELFOSABI_GNU	3U /* GNU */
#define ELFOSABI_HURD	4U /* GNU/HURD */
#define ELFOSABI_86OPEN	5U /* 86Open Common ABI */
#define ELFOSABI_SOLARIS 6U /* Sun Solaris */
#define ELFOSABI_AIX	7U /* AIX */
#define ELFOSABI_IRIX	8U /* IRIX */
#define ELFOSABI_FREEBSD 9U /* FreeBSD */
#define ELFOSABI_TRU64	10U /* Compaq TRU64 UNIX */
#define ELFOSABI_MODESTO 11U /* Novell Modesto */
#define ELFOSABI_OPENBSD 12U /* Open BSD */
#define ELFOSABI_OPENVMS 13U /* Open VMS */
#define ELFOSABI_NSK	14U /* Hewlett-Packard Non-Stop Kernel */
#define ELFOSABI_AROS	15U /* Amiga Research OS */
#define ELFOSABI_FENIXOS 16U /* The FenixOS highly scalable multi-core OS */
#define ELFOSABI_CLOUDABI 17U /* Nuxi CloudABI */
#define ELFOSABI_OPENVOS 18U /* Stratus Technologies OpenVOS */
#define ELFOSABI_ARM_AEABI 64U /* ARM specific symbol versioning extensions */
#define ELFOSABI_ARM	97U /* ARM ABI */
#define ELFOSABI_STANDALONE 255U /* Standalone (embedded) application */


/* OS ABI Aliases. */

#define ELFOSABI_LINUX	ELFOSABI_GNU


/*
 * ELF Machine types: (EM_*).
 */

#define EM_NONE		0 /* No machine */
#define EM_M32		1 /* AT&T WE 32100 */
#define EM_SPARC	2 /* SPARC */
#define EM_386		3 /* Intel 80386 */
#define EM_68K		4 /* Motorola 68000 */
#define EM_88K		5 /* Motorola 88000 */
#define EM_IAMCU	6 /* Intel MCU */
#define EM_860		7 /* Intel 80860 */
#define EM_MIPS		8 /* MIPS I Architecture */
#define EM_S370		9 /* IBM System/370 Processor */
#define EM_MIPS_RS3_LE	10 /* MIPS RS3000 Little-endian */
#define EM_PARISC	15 /* Hewlett-Packard PA-RISC */
#define EM_VPP500	17 /* Fujitsu VPP500 */
#define EM_SPARC32PLUS	18 /* Enhanced instruction set SPARC */
#define EM_960		19 /* Intel 80960 */
#define EM_PPC		20 /* PowerPC */
#define EM_PPC64	21 /* 64-bit PowerPC */
#define EM_S390		22 /* IBM System/390 Processor */
#define EM_SPU		23 /* IBM SPU/SPC */
#define EM_V800		36 /* NEC V800 */
#define EM_FR20		37 /* Fujitsu FR20 */
#define EM_RH32		38 /* TRW RH-32 */
#define EM_RCE		39 /* Motorola RCE */
#define EM_ARM		40 /* Advanced RISC Machines ARM */
#define EM_ALPHA	41 /* Digital Alpha */
#define EM_SH		42 /* Hitachi SH */
#define EM_SPARCV9	43 /* SPARC Version 9 */
#define EM_TRICORE	44 /* Siemens TriCore embedded processor */
#define EM_ARC		45 /* Argonaut RISC Core */
#define EM_H8_300	46 /* Hitachi H8/300 */
#define EM_H8_300H	47 /* Hitachi H8/300H */
#define EM_H8S		48 /* Hitachi H8S */
#define EM_H8_500	49 /* Hitachi H8/500 */
#define EM_IA_64	50 /* Intel IA-64 processor architecture */
#define EM_MIPS_X	51 /* Stanford MIPS-X */
#define EM_COLDFIRE	52 /* Motorola ColdFire */
#define EM_68HC12	53 /* Motorola M68HC12 */
#define EM_MMA		54 /* Fujitsu MMA Multimedia Accelerator */
#define EM_PCP		55 /* Siemens PCP */
#define EM_NCPU		56 /* Sony nCPU embedded RISC processor */
#define EM_NDR1		57 /* Denso NDR1 microprocessor */
#define EM_STARCORE	58 /* Motorola Star*Core processor */
#define EM_ME16		59 /* Toyota ME16 processor */
#define EM_ST100	60 /* STMicroelectronics ST100 processor */
#define EM_TINYJ	61 /* Advanced Logic Corp. TinyJ embedded processor family */
#define EM_X86_64	62 /* AMD x86-64 architecture */
#define EM_PDSP		63 /* Sony DSP Processor */
#define EM_PDP10	64 /* Digital Equipment Corp. PDP-10 */
#define EM_PDP11	65 /* Digital Equipment Corp. PDP-11 */
#define EM_FX66		66 /* Siemens FX66 microcontroller */
#define EM_ST9PLUS	67 /* STMicroelectronics ST9+ 8/16 bit microcontroller */
#define EM_ST7		68 /* STMicroelectronics ST7 8-bit microcontroller */
#define EM_68HC16	69 /* Motorola MC68HC16 Microcontroller */
#define EM_68HC11	70 /* Motorola MC68HC11 Microcontroller */
#define EM_68HC08	71 /* Motorola MC68HC08 Microcontroller */
#define EM_68HC05	72 /* Motorola MC68HC05 Microcontroller */
#define EM_SVX		73 /* Silicon Graphics SVx */
#define EM_ST19		74 /* STMicroelectronics ST19 8-bit microcontroller */
#define EM_VAX		75 /* Digital VAX */
#define EM_CRIS		76 /* Axis Communications 32-bit embedded processor */
#define EM_JAVELIN	77 /* Infineon Technologies 32-bit embedded processor */
#define EM_FIREPATH	78 /* Element 14 64-bit DSP Processor */
#define EM_ZSP		79 /* LSI Logic 16-bit DSP Processor */
#define EM_MMIX		80 /* Educational 64-bit processor by Donald Knuth */
#define EM_HUANY	81 /* Harvard University machine-independent object files */
#define EM_PRISM	82 /* SiTera Prism */
#define EM_AVR		83 /* Atmel AVR 8-bit microcontroller */
#define EM_FR30		84 /* Fujitsu FR30 */
#define EM_D10V		85 /* Mitsubishi D10V */
#define EM_D30V		86 /* Mitsubishi D30V */
#define EM_V850		87 /* NEC v850 */
#define EM_M32R		88 /* Mitsubishi M32R */
#define EM_MN10300	89 /* Matsushita MN10300 */
#define EM_MN10200	90 /* Matsushita MN10200 */
#define EM_PJ		91 /* picoJava */
#define EM_OPENRISC	92 /* OpenRISC 32-bit embedded processor */
#define EM_ARC_COMPACT	93 /* ARC International ARCompact processor */
#define EM_XTENSA	94 /* Tensilica Xtensa Architecture */
#define EM_VIDEOCORE	95 /* Alphamosaic VideoCore processor */
#define EM_TMM_GPP	96 /* Thompson Multimedia General Purpose Processor */
#define EM_NS32K	97 /* National Semiconductor 32000 series */
#define EM_TPC		98 /* Tenor Network TPC processor */
#define EM_SNP1K	99 /* Trebia SNP 1000 processor */
#define EM_ST200	100 /* STMicroelectronics (www.st.com) ST200 microcontroller */
#define EM_IP2K		101 /* Ubicom IP2xxx microcontroller family */
#define EM_MAX		102 /* MAX Processor */
#define EM_CR		103 /* National Semiconductor CompactRISC microprocessor */
#define EM_F2MC16	104 /* Fujitsu F2MC16 */
#define EM_MSP430	105 /* Texas Instruments embedded microcontroller msp430 */
#define EM_BLACKFIN	106 /* Analog Devices Blackfin (DSP) processor */
#define EM_SE_C33	107 /* S1C33 Family of Seiko Epson processors */
#define EM_SEP		108 /* Sharp embedded microprocessor */
#define EM_ARCA		109 /* Arca RISC Microprocessor */
#define EM_UNICORE	110 /* Microprocessor series from PKU-Unity Ltd. and MPRC of Peking University */
#define EM_EXCESS	111 /* eXcess: 16/32/64-bit configurable embedded CPU */
#define EM_DXP		112 /* Icera Semiconductor Inc. Deep Execution Processor */
#define EM_ALTERA_NIOS2	113 /* Altera Nios II soft-core processor */
#define EM_CRX		114 /* National Semiconductor CompactRISC CRX microprocessor */
#define EM_XGATE	115 /* Motorola XGATE embedded processor */
#define EM_C166		116 /* Infineon C16x/XC16x processor */
#define EM_M16C		117 /* Renesas M16C series microprocessors */
#define EM_DSPIC30F	118 /* Microchip Technology dsPIC30F Digital Signal Controller */
#define EM_CE		119 /* Freescale Communication Engine RISC core */
#define EM_M32C		120 /* Renesas M32C series microprocessors */
#define EM_TSK3000	131 /* Altium TSK3000 core */
#define EM_RS08		132 /* Freescale RS08 embedded processor */
#define EM_SHARC	133 /* Analog Devices SHARC family of 32-bit DSP processors */
#define EM_ECOG2	134 /* Cyan Technology eCOG2 microprocessor */
#define EM_SCORE7	135 /* Sunplus S+core7 RISC processor */
#define EM_DSP24	136 /* New Japan Radio (NJR) 24-bit DSP Processor */
#define EM_VIDEOCORE3	137 /* Broadcom VideoCore III processor */
#define EM_LATTICEMICO32 138 /* RISC processor for Lattice FPGA architecture */
#define EM_SE_C17	139 /* Seiko Epson C17 family */
#define EM_TI_C6000	140 /* The Texas Instruments TMS320C6000 DSP family */
#define EM_TI_C2000	141 /* The Texas Instruments TMS320C2000 DSP family */
#define EM_TI_C5500	142 /* The Texas Instruments TMS320C55x DSP family */
#define EM_TI_ARP32	143 /* Texas Instruments Application Specific RISC Processor */
#define EM_TI_PRU	144 /* Texas Instruments Programmable Realtime Unit */
#define EM_MMDSP_PLUS	160 /* STMicroelectronics 64bit VLIW Data Signal Processor */
#define EM_CYPRESS_M8C	161 /* Cypress M8C microprocessor */
#define EM_R32C		162 /* Renesas R32C series microprocessors */
#define EM_TRIMEDIA	163 /* NXP Semiconductors TriMedia architecture family */
#define EM_QDSP6	164 /* QUALCOMM DSP6 Processor */
#define EM_8051		165 /* Intel 8051 and variants */
#define EM_STXP7X	166 /* STMicroelectronics STxP7x family of configurable and extensible RISC processors */
#define EM_NDS32	167 /* Andes Technology compact code size embedded RISC processor family */
#define EM_ECOG1X	168 /* Cyan Technology eCOG1X family */
#define EM_MAXQ30	169 /* Dallas Semiconductor MAXQ30 Core Micro-controllers */
#define EM_XIMO16	170 /* New Japan Radio (NJR) 16-bit DSP Processor */
#define EM_MANIK	171 /* M2000 Reconfigurable RISC Microprocessor */
#define EM_CRAYNV2	172 /* Cray Inc. NV2 vector architecture */
#define EM_RX		173 /* Renesas RX family */
#define EM_METAG	174 /* Imagination Technologies META processor architecture */
#define EM_MCST_ELBRUS	175 /* MCST Elbrus general purpose hardware architecture */
#define EM_ECOG16	176 /* Cyan Technology eCOG16 family */
#define EM_CR16		177 /* National Semiconductor CompactRISC CR16 16-bit microprocessor */
#define EM_ETPU		178 /* Freescale Extended Time Processing Unit */
#define EM_SLE9X	179 /* Infineon Technologies SLE9X core */
#define EM_L10M		180 /* Intel L10M */
#define EM_K10M		181 /* Intel K10M */
#define EM_AARCH64	183 /* AArch64 (64-bit ARM) */
#define EM_AVR32	185 /* Atmel Corporation 32-bit microprocessor family */
#define EM_STM8		186 /* STMicroeletronics STM8 8-bit microcontroller */
#define EM_TILE64	187 /* Tilera TILE64 multicore architecture family */
#define EM_TILEPRO	188 /* Tilera TILEPro multicore architecture family */
#define EM_MICROBLAZE	189 /* Xilinx MicroBlaze 32-bit RISC soft processor core */
#define EM_CUDA		190 /* NVIDIA CUDA architecture */
#define EM_TILEGX	191 /* Tilera TILE-Gx multicore architecture family */
#define EM_CLOUDSHIELD	192 /* CloudShield architecture family */
#define EM_COREA_1ST	193 /* KIPO-KAIST Core-A 1st generation processor family */
#define EM_COREA_2ND	194 /* KIPO-KAIST Core-A 2nd generation processor family */
#define EM_ARC_COMPACT2	195 /* Synopsys ARCompact V2 */
#define EM_OPEN8	196 /* Open8 8-bit RISC soft processor core */
#define EM_RL78		197 /* Renesas RL78 family */
#define EM_VIDEOCORE5	198 /* Broadcom VideoCore V processor */
#define EM_78KOR	199 /* Renesas 78KOR family */
#define EM_56800EX	200 /* Freescale 56800EX Digital Signal Controller */
#define EM_BA1		201 /* Beyond BA1 CPU architecture */
#define EM_BA2		202 /* Beyond BA2 CPU architecture */
#define EM_XCORE	203 /* XMOS xCORE processor family */
#define EM_MCHP_PIC	204 /* Microchip 8-bit PIC(r) family */
#define EM_INTELGT	205 /* Intel Graphics Technology */
#define EM_INTEL206	206 /* Reserved by Intel */
#define EM_INTEL207	207 /* Reserved by Intel */
#define EM_INTEL208	208 /* Reserved by Intel */
#define EM_INTEL209	209 /* Reserved by Intel */
#define EM_KM32		210 /* KM211 KM32 32-bit processor */
#define EM_KMX32	211 /* KM211 KMX32 32-bit processor */
#define EM_KMX16	212 /* KM211 KMX16 16-bit processor */
#define EM_KMX8		213 /* KM211 KMX8 8-bit processor */
#define EM_KVARC	214 /* KM211 KMX32 KVARC processor */
#define EM_CDP		215 /* Paneve CDP architecture family */
#define EM_COGE		216 /* Cognitive Smart Memory Processor */
#define EM_COOL		217 /* Bluechip Systems CoolEngine */
#define EM_NORC		218 /* Nanoradio Optimized RISC */
#define EM_CSR_KALIMBA	219 /* CSR Kalimba architecture family */
#define EM_Z80		220 /* Zilog Z80 */
#define EM_VISIUM	221 /* Controls and Data Services VISIUMcore processor */
#define EM_FT32		222 /* FTDI Chip FT32 high performance 32-bit RISC architecture */
#define EM_MOXIE	223 /* Moxie processor family */
#define EM_AMDGPU	224 /* AMD GPU architecture */
#define EM_RISCV	243 /* RISC-V */
#define EM_LANAI	244 /* Lanai processor */
#define EM_CEVA		245 /* CEVA Processor Architecture Family */
#define EM_CEVA_X2	246 /* CEVA X2 Processor Family */
#define EM_BPF		247 /* Linux BPF – in-kernel virtual machine */
#define EM_GRAPHCORE_IPU 248 /* Graphcore Intelligent Processing Unit */
#define EM_IMG1		249 /* Imagination Technologies */
#define EM_NFP		250 /* Netronome Flow Processor (NFP) */
#define EM_VE		251 /* NEC Vector Engine */
#define EM_CSKY		252 /* C-SKY processor family */
#define EM_ARC_COMPACT3_64 253 /* Synopsys ARCv2.3 64-bit */
#define EM_MCS6502	254 /* MOS Technology MCS 6502 processor */
#define EM_ARC_COMPACT3	255 /* Synopsys ARCv2.3 32-bit */
#define EM_KVX		256 /* Kalray VLIW core of the MPPA processor family */
#define EM_65816	257 /* WDC 65816/65C816 */
#define EM_LOONGARCH	258 /* Loongson LoongArch */
#define EM_KF32		259 /* ChipON KungFu 32 */
#define EM_U16_U8CORE	260 /* LAPIS nX-U16/U8 */
#define EM_TACHYUM	261 /* Reserved for Tachyum processor */
#define EM_56800EF	262 /* NXP 56800EF Digital Signal Controller (DSC) */
#define EM_SBF		263 /* Solana Bytecode Format */
#define EM_AIENGINE	264 /* AMD/Xilinx AIEngine architecture */
#define EM_SIMA_MLA	265 /* SiMa MLA */
#define EM_BANG		266 /* Cambricon BANG */
#define EM_LOONGGPU	267 /* Loongson LoongArch GPU */

/* Other synonyms. */

#define EM_AMD64	EM_X86_64
#define EM_ARC_A5	EM_ARC_COMPACT
#define EM_ECOG1	EM_ECOG1X


/*
 * ELF file types: (ET_*).
 */

#define ET_NONE		0U /* No file type */
#define ET_REL		1U /* Relocatable object */
#define ET_EXEC		2U /* Executable */
#define ET_DYN		3U /* Shared object */
#define ET_CORE		4U /* Core file */
#define ET_LOOS		0xFE00U /* Begin OS-specific range */
#define ET_HIOS		0xFEFFU /* End OS-specific range */
#define ET_LOPROC	0xFF00U /* Begin processor-specific range */
#define ET_HIPROC	0xFFFFU /* End processor-specific range */


/* ELF file format version numbers. */

#define EV_NONE		0U
#define EV_CURRENT	1U


/*
 * Flags for section groups.
 */

#define GRP_COMDAT	0x1 /* COMDAT semantics */
#define GRP_MASKOS	0x0ff00000 /* OS-specific flags */
#define GRP_MASKPROC	0xf0000000 /* processor-specific flags */


/*
 * Flags / mask for .gnu.versym sections.
 */

#define VERSYM_VERSION	0x7fff
#define VERSYM_HIDDEN	0x8000


/*
 * Flags used by program header table entries.
 */

#define PF_X		0x1 /* Execute */
#define PF_W		0x2 /* Write */
#define PF_R		0x4 /* Read */
#define PF_MASKOS	0x0ff00000 /* OS-specific flags */
#define PF_MASKPROC	0xf0000000 /* Processor-specific flags */
#define PF_ARM_SB	0x10000000 /* segment contains the location addressed by the static base */
#define PF_ARM_PI	0x20000000 /* segment is position-independent */
#define PF_ARM_ABS	0x40000000 /* segment must be loaded at its base address */


/*
 * Types of program header table entries.
 */

#define PT_NULL		0U /* ignored entry */
#define PT_LOAD		1U /* loadable segment */
#define PT_DYNAMIC	2U /* contains dynamic linking information */
#define PT_INTERP	3U /* names an interpreter */
#define PT_NOTE		4U /* auxiliary information */
#define PT_SHLIB	5U /* reserved */
#define PT_PHDR		6U /* describes the program header itself */
#define PT_TLS		7U /* thread local storage */
#define PT_LOOS		0x60000000U /* start of OS-specific range */
#define PT_SUNW_UNWIND	0x6464E550U /* Solaris/amd64 stack unwind tables */
#define PT_GNU_EH_FRAME	0x6474E550U /* GCC generated .eh_frame_hdr segment */
#define PT_GNU_STACK	0x6474E551U /* Stack flags */
#define PT_GNU_RELRO	0x6474E552U /* Segment becomes read-only after relocation */
#define PT_OPENBSD_RANDOMIZE 0x65A3DBE6U /* Segment filled with random data */
#define PT_OPENBSD_WXNEEDED 0x65A3DBE7U /* Program violates W^X */
#define PT_OPENBSD_BOOTDATA 0x65A41BE6U /* Boot data */
#define PT_SUNWBSS	0x6FFFFFFAU /* A Solaris .SUNW_bss section */
#define PT_SUNWSTACK	0x6FFFFFFBU /* A Solaris process stack */
#define PT_SUNWDTRACE	0x6FFFFFFCU /* Used by dtrace(1) */
#define PT_SUNWCAP	0x6FFFFFFDU /* Special hardware capability requirements */
#define PT_HIOS		0x6FFFFFFFU /* end of OS-specific range */
#define PT_LOPROC	0x70000000U /* start of processor-specific range */
#define PT_ARM_ARCHEXT	0x70000000U /* platform architecture compatibility information */
#define PT_ARM_EXIDX	0x70000001U /* exception unwind tables */
#define PT_MIPS_REGINFO	0x70000000U /* register usage information */
#define PT_MIPS_RTPROC	0x70000001U /* runtime procedure table */
#define PT_MIPS_OPTIONS	0x70000002U /* options segment */
#define PT_HIPROC	0x7FFFFFFFU /* end of processor-specific range */

/* synonyms. */

#define PT_ARM_UNWIND	PT_ARM_EXIDX
#define PT_HISUNW	PT_HIOS
#define PT_LOSUNW	PT_SUNWBSS


/*
 * Section flags.
 */

#define SHF_WRITE	0x1U /* writable during program execution */
#define SHF_ALLOC	0x2U /* occupies memory during program execution */
#define SHF_EXECINSTR	0x4U /* executable instructions */
#define SHF_MERGE	0x10U /* may be merged to prevent duplication */
#define SHF_STRINGS	0x20U /* NUL-terminated character strings */
#define SHF_INFO_LINK	0x40U /* the sh_info field holds a link */
#define SHF_LINK_ORDER	0x80U /* special ordering requirements during linking */
#define SHF_OS_NONCONFORMING 0x100U /* requires OS-specific processing during linking */
#define SHF_GROUP	0x200U /* member of a section group */
#define SHF_TLS		0x400U /* holds thread-local storage */
#define SHF_COMPRESSED	0x800U /* holds compressed data */
#define SHF_MASKOS	0x0FF00000U /* bits reserved for OS-specific semantics */
#define SHF_AMD64_LARGE	0x10000000U /* section uses large code model */
#define SHF_ENTRYSECT	0x10000000U /* section contains an entry point (ARM) */
#define SHF_COMDEF	0x80000000U /* section may be multiply defined in input to link step (ARM) */
#define SHF_MIPS_GPREL	0x10000000U /* section must be part of global data area */
#define SHF_MIPS_MERGE	0x20000000U /* section data should be merged to eliminate duplication */
#define SHF_MIPS_ADDR	0x40000000U /* section data is addressed by default */
#define SHF_MIPS_STRING	0x80000000U /* section data is string data by default */
#define SHF_MIPS_NOSTRIP 0x08000000U /* section data may not be stripped */
#define SHF_MIPS_LOCAL	0x04000000U /* section data local to process */
#define SHF_MIPS_NAMES	0x02000000U /* linker must generate implicit hidden weak names */
#define SHF_MIPS_NODUPE	0x01000000U /* linker must retain only one copy */
#define SHF_ORDERED	0x40000000U /* section is ordered with respect to other sections */
#define SHF_EXCLUDE	0x80000000U /* section is excluded from executables and shared objects */
#define SHF_MASKPROC	0xF0000000U /* bits reserved for processor-specific semantics */


/*
 * Special section indices.
 */

#define SHN_UNDEF	0U /* undefined section */
#define SHN_LORESERVE	0xFF00U /* start of reserved area */
#define SHN_LOPROC	0xFF00U /* start of processor-specific range */
#define SHN_BEFORE	0xFF00U /* used for section ordering */
#define SHN_AFTER	0xFF01U /* used for section ordering */
#define SHN_AMD64_LCOMMON 0xFF02U /* large common block label */
#define SHN_MIPS_ACOMMON 0xFF00U /* allocated common symbols in a DSO */
#define SHN_MIPS_TEXT	0xFF01U /* Reserved (obsolete) */
#define SHN_MIPS_DATA	0xFF02U /* Reserved (obsolete) */
#define SHN_MIPS_SCOMMON 0xFF03U /* gp-addressable common symbols */
#define SHN_MIPS_SUNDEFINED 0xFF04U /* gp-addressable undefined symbols */
#define SHN_MIPS_LCOMMON 0xFF05U /* local common symbols */
#define SHN_MIPS_LUNDEFINED 0xFF06U /* local undefined symbols */
#define SHN_HIPROC	0xFF1FU /* end of processor-specific range */
#define SHN_LOOS	0xFF20U /* start of OS-specific range */
#define SHN_SUNW_IGNORE	0xFF3FU /* used by dtrace */
#define SHN_HIOS	0xFF3FU /* end of OS-specific range */
#define SHN_ABS		0xFFF1U /* absolute references */
#define SHN_COMMON	0xFFF2U /* references to COMMON areas */
#define SHN_XINDEX	0xFFFFU /* extended index */
#define SHN_HIRESERVE	0xFFFFU /* end of reserved area */


/*
 * Section types.
 */

#define SHT_NULL	0U /* inactive header */
#define SHT_PROGBITS	1U /* program defined information */
#define SHT_SYMTAB	2U /* symbol table */
#define SHT_STRTAB	3U /* string table */
#define SHT_RELA	4U /* relocation entries with addends */
#define SHT_HASH	5U /* symbol hash table */
#define SHT_DYNAMIC	6U /* information for dynamic linking */
#define SHT_NOTE	7U /* additional notes */
#define SHT_NOBITS	8U /* section occupying no space */
#define SHT_REL		9U /* relocation entries without addends */
#define SHT_SHLIB	10U /* reserved */
#define SHT_DYNSYM	11U /* symbol table */
#define SHT_INIT_ARRAY	14U /* pointers to initialization functions */
#define SHT_FINI_ARRAY	15U /* pointers to termination functions */
#define SHT_PREINIT_ARRAY 16U /* pointers to functions called before initialization */
#define SHT_GROUP	17U /* defines a section group */
#define SHT_SYMTAB_SHNDX 18U /* used for extended section numbering */
#define SHT_LOOS	0x60000000U /* start of OS-specific range */
#define SHT_SUNW_dof	0x6FFFFFF4U /* used by dtrace */
#define SHT_SUNW_cap	0x6FFFFFF5U /* capability requirements */
#define SHT_GNU_ATTRIBUTES 0x6FFFFFF5U /* object attributes */
#define SHT_SUNW_SIGNATURE 0x6FFFFFF6U /* module verification signature */
#define SHT_GNU_HASH	0x6FFFFFF6U /* GNU Hash sections */
#define SHT_GNU_LIBLIST	0x6FFFFFF7U /* List of libraries to be prelinked */
#define SHT_SUNW_ANNOTATE 0x6FFFFFF7U /* special section where unresolved references are allowed */
#define SHT_SUNW_DEBUGSTR 0x6FFFFFF8U /* debugging information */
#define SHT_CHECKSUM	0x6FFFFFF8U /* checksum for dynamic shared objects */
#define SHT_SUNW_DEBUG	0x6FFFFFF9U /* debugging information */
#define SHT_SUNW_move	0x6FFFFFFAU /* information to handle partially initialized symbols */
#define SHT_SUNW_COMDAT	0x6FFFFFFBU /* section supporting merging of multiple copies of data */
#define SHT_SUNW_syminfo 0x6FFFFFFCU /* additional symbol information */
#define SHT_SUNW_verdef	0x6FFFFFFDU /* symbol versioning information */
#define SHT_SUNW_verneed 0x6FFFFFFEU /* symbol versioning requirements */
#define SHT_SUNW_versym	0x6FFFFFFFU /* symbol versioning table */
#define SHT_HIOS	0x6FFFFFFFU /* end of OS-specific range */
#define SHT_LOPROC	0x70000000U /* start of processor-specific range */
#define SHT_ARM_EXIDX	0x70000001U /* exception index table */
#define SHT_ARM_PREEMPTMAP 0x70000002U /* BPABI DLL dynamic linking preemption map */
#define SHT_ARM_ATTRIBUTES 0x70000003U /* object file compatibility attributes */
#define SHT_ARM_DEBUGOVERLAY 0x70000004U /* overlay debug information */
#define SHT_ARM_OVERLAYSECTION 0x70000005U /* overlay debug information */
#define SHT_MIPS_LIBLIST 0x70000000U /* DSO library information used in link */
#define SHT_MIPS_MSYM	0x70000001U /* MIPS symbol table extension */
#define SHT_MIPS_CONFLICT 0x70000002U /* symbol conflicting with DSO-defined symbols  */
#define SHT_MIPS_GPTAB	0x70000003U /* global pointer table */
#define SHT_MIPS_UCODE	0x70000004U /* reserved */
#define SHT_MIPS_DEBUG	0x70000005U /* reserved (obsolete debug information) */
#define SHT_MIPS_REGINFO 0x70000006U /* register usage information */
#define SHT_MIPS_PACKAGE 0x70000007U /* OSF reserved */
#define SHT_MIPS_PACKSYM 0x70000008U /* OSF reserved */
#define SHT_MIPS_RELD	0x70000009U /* dynamic relocation */
#define SHT_MIPS_IFACE	0x7000000BU /* subprogram interface information */
#define SHT_MIPS_CONTENT 0x7000000CU /* section content classification */
#define SHT_MIPS_OPTIONS 0x7000000DU /* general options */
#define SHT_MIPS_DELTASYM 0x7000001BU /* Delta C++: symbol table */
#define SHT_MIPS_DELTAINST 0x7000001CU /* Delta C++: instance table */
#define SHT_MIPS_DELTACLASS 0x7000001DU /* Delta C++: class table */
#define SHT_MIPS_DWARF	0x7000001EU /* DWARF debug information */
#define SHT_MIPS_DELTADECL 0x7000001FU /* Delta C++: declarations */
#define SHT_MIPS_SYMBOL_LIB 0x70000020U /* symbol-to-library mapping */
#define SHT_MIPS_EVENTS	0x70000021U /* event locations */
#define SHT_MIPS_TRANSLATE 0x70000022U /* ??? */
#define SHT_MIPS_PIXIE	0x70000023U /* special pixie sections */
#define SHT_MIPS_XLATE	0x70000024U /* address translation table */
#define SHT_MIPS_XLATE_DEBUG 0x70000025U /* SGI internal address translation table */
#define SHT_MIPS_WHIRL	0x70000026U /* intermediate code */
#define SHT_MIPS_EH_REGION 0x70000027U /* C++ exception handling region info */
#define SHT_MIPS_XLATE_OLD 0x70000028U /* obsolete */
#define SHT_MIPS_PDR_EXCEPTION 0x70000029U /* runtime procedure descriptor table exception information */
#define SHT_MIPS_ABIFLAGS 0x7000002AU /* ABI flags */
#define SHT_SPARC_GOTDATA 0x70000000U /* SPARC-specific data */
#define SHT_X86_64_UNWIND 0x70000001U /* unwind tables for the AMD64 */
#define SHT_ORDERED	0x7FFFFFFFU /* sort entries in the section */
#define SHT_HIPROC	0x7FFFFFFFU /* end of processor-specific range */
#define SHT_LOUSER	0x80000000U /* start of application-specific range */
#define SHT_HIUSER	0xFFFFFFFFU /* end of application-specific range */

/* Aliases for section types. */

#define SHT_AMD64_UNWIND SHT_X86_64_UNWIND
#define SHT_GNU_verdef	SHT_SUNW_verdef
#define SHT_GNU_verneed	SHT_SUNW_verneed
#define SHT_GNU_versym	SHT_SUNW_versym


#define	PN_XNUM			0xFFFFU /* Use extended section numbering. */

/*
 * Symbol binding information.
 */

#define STB_LOCAL	0 /* not visible outside defining object file */
#define STB_GLOBAL	1 /* visible across all object files being combined */
#define STB_WEAK	2 /* visible across all object files but with low precedence */
#define STB_LOOS	10 /* start of OS-specific range */
#define STB_GNU_UNIQUE	10 /* unique symbol (GNU) */
#define STB_HIOS	12 /* end of OS-specific range */
#define STB_LOPROC	13 /* start of processor-specific range */
#define STB_HIPROC	15 /* end of processor-specific range */


/*
 * Symbol types
 */

#define STT_NOTYPE	0 /* unspecified type */
#define STT_OBJECT	1 /* data object */
#define STT_FUNC	2 /* executable code */
#define STT_SECTION	3 /* section */
#define STT_FILE	4 /* source file */
#define STT_COMMON	5 /* uninitialized common block */
#define STT_TLS		6 /* thread local storage */
#define STT_LOOS	10 /* start of OS-specific types */
#define STT_GNU_IFUNC	10 /* indirect function */
#define STT_HIOS	12 /* end of OS-specific types */
#define STT_LOPROC	13 /* start of processor-specific types */
#define STT_ARM_TFUNC	13 /* Thumb function (GNU) */
#define STT_ARM_16BIT	15 /* Thumb label (GNU) */
#define STT_SPARC_REGISTER 13 /* SPARC register information */
#define STT_HIPROC	15 /* end of processor-specific types */

/* Additional constants related to symbol types. */

#define STT_NUM		7 /* the number of symbol types */


/*
 * Symbol binding.
 */

#define SYMINFO_BT_SELF	0xFFFFU /* bound to self */
#define SYMINFO_BT_PARENT 0xFFFEU /* bound to parent */
#define SYMINFO_BT_NONE	0xFFFDU /* no special binding */


/*
 * Symbol visibility.
 */

#define STV_DEFAULT	0 /* as specified by symbol type */
#define STV_INTERNAL	1 /* as defined by processor semantics */
#define STV_HIDDEN	2 /* hidden from other components */
#define STV_PROTECTED	3 /* local references are not preemptable */


/*
 * Symbol flags.
 */

#define SYMINFO_FLG_DIRECT 0x01 /* directly assocated reference */
#define SYMINFO_FLG_COPY 0x04 /* definition by copy-relocation */
#define SYMINFO_FLG_LAZYLOAD 0x08 /* object should be lazily loaded */
#define SYMINFO_FLG_DIRECTBIND 0x10 /* reference should be directly bound */
#define SYMINFO_FLG_NOEXTDIRECT 0x20 /* external references not allowed to bind to definition */


/*
 * Versioning dependencies.
 */

#define VER_NDX_LOCAL	0 /* local scope */
#define VER_NDX_GLOBAL	1 /* global scope */


/*
 * Versioning flags.
 */

#define VER_FLG_BASE	0x1 /* file version */
#define VER_FLG_WEAK	0x2 /* weak version */


/*
 * Versioning needs
 */

#define VER_NEED_NONE	0 /* invalid version */
#define VER_NEED_CURRENT 1 /* current version */


/*
 * Versioning numbers.
 */

#define VER_DEF_NONE	0 /* invalid version */
#define VER_DEF_CURRENT	1 /* current version */


/**
 ** Relocation types.
 **/


#define R_386_NONE	0
#define R_386_32	1
#define R_386_PC32	2
#define R_386_GOT32	3
#define R_386_PLT32	4
#define R_386_COPY	5
#define R_386_GLOB_DAT	6
#define R_386_JMP_SLOT	7
#define R_386_JUMP_SLOT	7
#define R_386_RELATIVE	8
#define R_386_GOTOFF	9
#define R_386_GOTPC	10
#define R_386_32PLT	11
#define R_386_TLS_TPOFF	14
#define R_386_TLS_IE	15
#define R_386_TLS_GOTIE	16
#define R_386_TLS_LE	17
#define R_386_TLS_GD	18
#define R_386_TLS_LDM	19
#define R_386_16	20
#define R_386_PC16	21
#define R_386_8		22
#define R_386_PC8	23
#define R_386_TLS_GD_32	24
#define R_386_TLS_GD_PUSH 25
#define R_386_TLS_GD_CALL 26
#define R_386_TLS_GD_POP 27
#define R_386_TLS_LDM_32 28
#define R_386_TLS_LDM_PUSH 29
#define R_386_TLS_LDM_CALL 30
#define R_386_TLS_LDM_POP 31
#define R_386_TLS_LDO_32 32
#define R_386_TLS_IE_32	33
#define R_386_TLS_LE_32	34
#define R_386_TLS_DTPMOD32 35
#define R_386_TLS_DTPOFF32 36
#define R_386_TLS_TPOFF32 37
#define R_386_SIZE32	38
#define R_386_TLS_GOTDESC 39
#define R_386_TLS_DESC_CALL 40
#define R_386_TLS_DESC	41
#define R_386_IRELATIVE	42
#define R_386_GOT32X	43


#define R_AARCH64_NONE	0
#define R_AARCH64_ABS64	257
#define R_AARCH64_ABS32	258
#define R_AARCH64_ABS16	259
#define R_AARCH64_PREL64 260
#define R_AARCH64_PREL32 261
#define R_AARCH64_PREL16 262
#define R_AARCH64_MOVW_UABS_G0 263
#define R_AARCH64_MOVW_UABS_G0_NC 264
#define R_AARCH64_MOVW_UABS_G1 265
#define R_AARCH64_MOVW_UABS_G1_NC 266
#define R_AARCH64_MOVW_UABS_G2 267
#define R_AARCH64_MOVW_UABS_G2_NC 268
#define R_AARCH64_MOVW_UABS_G3 269
#define R_AARCH64_MOVW_SABS_G0 270
#define R_AARCH64_MOVW_SABS_G1 271
#define R_AARCH64_MOVW_SABS_G2 272
#define R_AARCH64_LD_PREL_LO19 273
#define R_AARCH64_ADR_PREL_LO21 274
#define R_AARCH64_ADR_PREL_PG_HI21 275
#define R_AARCH64_ADR_PREL_PG_HI21_NC 276
#define R_AARCH64_ADD_ABS_LO12_NC 277
#define R_AARCH64_LDST8_ABS_LO12_NC 278
#define R_AARCH64_TSTBR14 279
#define R_AARCH64_CONDBR19 280
#define R_AARCH64_JUMP26 282
#define R_AARCH64_CALL26 283
#define R_AARCH64_LDST16_ABS_LO12_NC 284
#define R_AARCH64_LDST32_ABS_LO12_NC 285
#define R_AARCH64_LDST64_ABS_LO12_NC 286
#define R_AARCH64_MOVW_PREL_G0 287
#define R_AARCH64_MOVW_PREL_G0_NC 288
#define R_AARCH64_MOVW_PREL_G1 289
#define R_AARCH64_MOVW_PREL_G1_NC 290
#define R_AARCH64_MOVW_PREL_G2 291
#define R_AARCH64_MOVW_PREL_G2_NC 292
#define R_AARCH64_MOVW_PREL_G3 293
#define R_AARCH64_LDST128_ABS_LO12_NC 299
#define R_AARCH64_MOVW_GOTOFF_G0 300
#define R_AARCH64_MOVW_GOTOFF_G0_NC 301
#define R_AARCH64_MOVW_GOTOFF_G1 302
#define R_AARCH64_MOVW_GOTOFF_G1_NC 303
#define R_AARCH64_MOVW_GOTOFF_G2 304
#define R_AARCH64_MOVW_GOTOFF_G2_NC 305
#define R_AARCH64_MOVW_GOTOFF_G3 306
#define R_AARCH64_GOTREL64 307
#define R_AARCH64_GOTREL32 308
#define R_AARCH64_GOT_LD_PREL19 309
#define R_AARCH64_LD64_GOTOFF_LO15 310
#define R_AARCH64_ADR_GOT_PAGE 311
#define R_AARCH64_LD64_GOT_LO12_NC 312
#define R_AARCH64_LD64_GOTPAGE_LO15 313
#define R_AARCH64_TLSGD_ADR_PREL21 512
#define R_AARCH64_TLSGD_ADR_PAGE21 513
#define R_AARCH64_TLSGD_ADD_LO12_NC 514
#define R_AARCH64_TLSGD_MOVW_G1 515
#define R_AARCH64_TLSGD_MOVW_G0_NC 516
#define R_AARCH64_TLSLD_ADR_PREL21 517
#define R_AARCH64_TLSLD_ADR_PAGE21 518
#define R_AARCH64_TLSLD_ADD_LO12_NC 519
#define R_AARCH64_TLSLD_MOVW_G1 520
#define R_AARCH64_TLSLD_MOVW_G0_NC 521
#define R_AARCH64_TLSLD_LD_PREL19 522
#define R_AARCH64_TLSLD_MOVW_DTPREL_G2 523
#define R_AARCH64_TLSLD_MOVW_DTPREL_G1 524
#define R_AARCH64_TLSLD_MOVW_DTPREL_G1_NC 525
#define R_AARCH64_TLSLD_MOVW_DTPREL_G0 526
#define R_AARCH64_TLSLD_MOVW_DTPREL_G0_NC 527
#define R_AARCH64_TLSLD_ADD_DTPREL_HI12 529
#define R_AARCH64_TLSLD_ADD_DTPREL_LO12_NC 530
#define R_AARCH64_TLSLD_LDST8_DTPREL_LO12 531
#define R_AARCH64_TLSLD_LDST8_DTPREL_LO12_NC 532
#define R_AARCH64_TLSLD_LDST16_DTPREL_LO12 533
#define R_AARCH64_TLSLD_LDST16_DTPREL_LO12_NC 534
#define R_AARCH64_TLSLD_LDST32_DTPREL_LO12 535
#define R_AARCH64_TLSLD_LDST32_DTPREL_LO12_NC 536
#define R_AARCH64_TLSLD_LDST64_DTPREL_LO12 537
#define R_AARCH64_TLSLD_LDST64_DTPREL_LO12_NC 538
#define R_AARCH64_TLSIE_MOVW_GOTTPREL_G1 539
#define R_AARCH64_TLSIE_MOVW_GOTTPREL_G0_NC 540
#define R_AARCH64_TLSIE_ADR_GOTTPREL_PAGE21 541
#define R_AARCH64_TLSIE_LD64_GOTTPREL_LO12_NC 542
#define R_AARCH64_TLSIE_LD_GOTTPREL_PREL19 543
#define R_AARCH64_TLSLE_MOVW_TPREL_G2 544
#define R_AARCH64_TLSLE_MOVW_TPREL_G1 545
#define R_AARCH64_TLSLE_MOVW_TPREL_G1_NC 546
#define R_AARCH64_TLSLE_MOVW_TPREL_G0 547
#define R_AARCH64_TLSLE_MOVW_TPREL_G0_NC 548
#define R_AARCH64_TLSLE_ADD_TPREL_HI12 549
#define R_AARCH64_TLSLE_ADD_TPREL_LO12 550
#define R_AARCH64_TLSLE_ADD_TPREL_LO12_NC 551
#define R_AARCH64_TLSLE_LDST8_TPREL_LO12 552
#define R_AARCH64_TLSLE_LDST8_TPREL_LO12_NC 553
#define R_AARCH64_TLSLE_LDST16_TPREL_LO12 554
#define R_AARCH64_TLSLE_LDST16_TPREL_LO12_NC 555
#define R_AARCH64_TLSLE_LDST32_TPREL_LO12 556
#define R_AARCH64_TLSLE_LDST32_TPREL_LO12_NC 557
#define R_AARCH64_TLSLE_LDST64_TPREL_LO12 558
#define R_AARCH64_TLSLE_LDST64_TPREL_LO12_NC 559
#define R_AARCH64_TLSDESC_LD_PREL19 560
#define R_AARCH64_TLSDESC_ADR_PREL21 561
#define R_AARCH64_TLSDESC_ADR_PAGE21 562
#define R_AARCH64_TLSDESC_LD64_LO12 563
#define R_AARCH64_TLSDESC_ADD_LO12 564
#define R_AARCH64_TLSDESC_OFF_G1 565
#define R_AARCH64_TLSDESC_OFF_G0_NC 566
#define R_AARCH64_TLSDESC_LDR 567
#define R_AARCH64_TLSDESC_ADD 568
#define R_AARCH64_TLSDESC_CALL 569
#define R_AARCH64_TLSLE_LDST128_TPREL_LO12 570
#define R_AARCH64_TLSLE_LDST128_TPREL_LO12_NC 571
#define R_AARCH64_TLSLD_LDST128_DTPREL_LO12 572
#define R_AARCH64_TLSLD_LDST128_DTPREL_LO12_NC 573
#define R_AARCH64_COPY	1024
#define R_AARCH64_GLOB_DAT 1025
#define R_AARCH64_JUMP_SLOT 1026
#define R_AARCH64_RELATIVE 1027
#define R_AARCH64_TLS_DTPREL64 1028
#define R_AARCH64_TLS_DTPMOD64 1029
#define R_AARCH64_TLS_TPREL64 1030
#define R_AARCH64_TLSDESC 1031
#define R_AARCH64_IRELATIVE 1032


#define R_AMD64_NONE	0
#define R_AMD64_64	1
#define R_AMD64_PC32	2
#define R_AMD64_GOT32	3
#define R_AMD64_PLT32	4
#define R_AMD64_COPY	5
#define R_AMD64_GLOB_DAT 6
#define R_AMD64_JUMP_SLOT 7
#define R_AMD64_RELATIVE 8
#define R_AMD64_GOTPCREL 9
#define R_AMD64_32	10
#define R_AMD64_32S	11
#define R_AMD64_16	12
#define R_AMD64_PC16	13
#define R_AMD64_8	14
#define R_AMD64_PC8	15
#define R_AMD64_PC64	24
#define R_AMD64_GOTOFF64 25
#define R_AMD64_GOTPC32	26


#define R_ARM_NONE	0
#define R_ARM_PC24	1
#define R_ARM_ABS32	2
#define R_ARM_REL32	3
#define R_ARM_LDR_PC_G0	4
#define R_ARM_ABS16	5
#define R_ARM_ABS12	6
#define R_ARM_THM_ABS5	7
#define R_ARM_ABS8	8
#define R_ARM_SBREL32	9
#define R_ARM_THM_CALL	10
#define R_ARM_THM_PC8	11
#define R_ARM_BREL_ADJ	12
#define R_ARM_SWI24	13
#define R_ARM_TLS_DESC	13
#define R_ARM_THM_SWI8	14
#define R_ARM_XPC25	15
#define R_ARM_THM_XPC22	16
#define R_ARM_TLS_DTPMOD32 17
#define R_ARM_TLS_DTPOFF32 18
#define R_ARM_TLS_TPOFF32 19
#define R_ARM_COPY	20
#define R_ARM_GLOB_DAT	21
#define R_ARM_JUMP_SLOT	22
#define R_ARM_RELATIVE	23
#define R_ARM_GOTOFF32	24
#define R_ARM_BASE_PREL	25
#define R_ARM_GOT_BREL	26
#define R_ARM_PLT32	27
#define R_ARM_CALL	28
#define R_ARM_JUMP24	29
#define R_ARM_THM_JUMP24 30
#define R_ARM_BASE_ABS	31
#define R_ARM_ALU_PCREL_7_0 32
#define R_ARM_ALU_PCREL_15_8 33
#define R_ARM_ALU_PCREL_23_15 34
#define R_ARM_LDR_SBREL_11_0_NC 35
#define R_ARM_ALU_SBREL_19_12_NC 36
#define R_ARM_ALU_SBREL_27_20_CK 37
#define R_ARM_TARGET1	38
#define R_ARM_SBREL31	39
#define R_ARM_V4BX	40
#define R_ARM_TARGET2	41
#define R_ARM_PREL31	42
#define R_ARM_MOVW_ABS_NC 43
#define R_ARM_MOVT_ABS	44
#define R_ARM_MOVW_PREL_NC 45
#define R_ARM_MOVT_PREL	46
#define R_ARM_THM_MOVW_ABS_NC 47
#define R_ARM_THM_MOVT_ABS 48
#define R_ARM_THM_MOVW_PREL_NC 49
#define R_ARM_THM_MOVT_PREL 50
#define R_ARM_THM_JUMP19 51
#define R_ARM_THM_JUMP6	52
#define R_ARM_THM_ALU_PREL_11_0 53
#define R_ARM_THM_PC12	54
#define R_ARM_ABS32_NOI	55
#define R_ARM_REL32_NOI	56
#define R_ARM_ALU_PC_G0_NC 57
#define R_ARM_ALU_PC_G0	58
#define R_ARM_ALU_PC_G1_NC 59
#define R_ARM_ALU_PC_G1	60
#define R_ARM_ALU_PC_G2	61
#define R_ARM_LDR_PC_G1	62
#define R_ARM_LDR_PC_G2	63
#define R_ARM_LDRS_PC_G0 64
#define R_ARM_LDRS_PC_G1 65
#define R_ARM_LDRS_PC_G2 66
#define R_ARM_LDC_PC_G0	67
#define R_ARM_LDC_PC_G1	68
#define R_ARM_LDC_PC_G2	69
#define R_ARM_ALU_SB_G0_NC 70
#define R_ARM_ALU_SB_G0	71
#define R_ARM_ALU_SB_G1_NC 72
#define R_ARM_ALU_SB_G1	73
#define R_ARM_ALU_SB_G2	74
#define R_ARM_LDR_SB_G0	75
#define R_ARM_LDR_SB_G1	76
#define R_ARM_LDR_SB_G2	77
#define R_ARM_LDRS_SB_G0 78
#define R_ARM_LDRS_SB_G1 79
#define R_ARM_LDRS_SB_G2 80
#define R_ARM_LDC_SB_G0	81
#define R_ARM_LDC_SB_G1	82
#define R_ARM_LDC_SB_G2	83
#define R_ARM_MOVW_BREL_NC 84
#define R_ARM_MOVT_BREL	85
#define R_ARM_MOVW_BREL	86
#define R_ARM_THM_MOVW_BREL_NC 87
#define R_ARM_THM_MOVT_BREL 88
#define R_ARM_THM_MOVW_BREL 89
#define R_ARM_TLS_GOTDESC 90
#define R_ARM_TLS_CALL	91
#define R_ARM_TLS_DESCSEQ 92
#define R_ARM_THM_TLS_CALL 93
#define R_ARM_PLT32_ABS	94
#define R_ARM_GOT_ABS	95
#define R_ARM_GOT_PREL	96
#define R_ARM_GOT_BREL12 97
#define R_ARM_GOTOFF12	98
#define R_ARM_GOTRELAX	99
#define R_ARM_GNU_VTENTRY 100
#define R_ARM_GNU_VTINHERIT 101
#define R_ARM_THM_JUMP11 102
#define R_ARM_THM_JUMP8	103
#define R_ARM_TLS_GD32	104
#define R_ARM_TLS_LDM32	105
#define R_ARM_TLS_LDO32	106
#define R_ARM_TLS_IE32	107
#define R_ARM_TLS_LE32	108
#define R_ARM_TLS_LDO12	109
#define R_ARM_TLS_LE12	110
#define R_ARM_TLS_IE12GP 111
#define R_ARM_PRIVATE_0	112
#define R_ARM_PRIVATE_1	113
#define R_ARM_PRIVATE_2	114
#define R_ARM_PRIVATE_3	115
#define R_ARM_PRIVATE_4	116
#define R_ARM_PRIVATE_5	117
#define R_ARM_PRIVATE_6	118
#define R_ARM_PRIVATE_7	119
#define R_ARM_PRIVATE_8	120
#define R_ARM_PRIVATE_9	121
#define R_ARM_PRIVATE_10 122
#define R_ARM_PRIVATE_11 123
#define R_ARM_PRIVATE_12 124
#define R_ARM_PRIVATE_13 125
#define R_ARM_PRIVATE_14 126
#define R_ARM_PRIVATE_15 127
#define R_ARM_ME_TOO	128
#define R_ARM_THM_TLS_DESCSEQ16 129
#define R_ARM_THM_TLS_DESCSEQ32 130
#define R_ARM_THM_GOT_BREL12 131
#define R_ARM_IRELATIVE	140


#define R_IA_64_NONE	0
#define R_IA64_NONE	0
#define R_IA_64_IMM14	0x21
#define R_IA64_IMM14	0x21
#define R_IA_64_IMM22	0x22
#define R_IA64_IMM22	0x22
#define R_IA_64_IMM64	0x23
#define R_IA64_IMM64	0x23
#define R_IA_64_DIR32MSB 0x24
#define R_IA64_DIR32MSB	0x24
#define R_IA_64_DIR32LSB 0x25
#define R_IA64_DIR32LSB	0x25
#define R_IA_64_DIR64MSB 0x26
#define R_IA64_DIR64MSB	0x26
#define R_IA_64_DIR64LSB 0x27
#define R_IA64_DIR64LSB	0x27
#define R_IA_64_GPREL22	0x2a
#define R_IA64_GPREL22	0x2a
#define R_IA_64_GPREL64I 0x2b
#define R_IA64_GPREL64I	0x2b
#define R_IA_64_GPREL32MSB 0x2c
#define R_IA_64_GPREL32LSB 0x2d
#define R_IA_64_GPREL64MSB 0x2e
#define R_IA64_GPREL64MSB 0x2e
#define R_IA_64_GPREL64LSB 0x2f
#define R_IA64_GPREL64LSB 0x2f
#define R_IA_64_LTOFF22	0x32
#define R_IA64_LTOFF22	0x32
#define R_IA_64_LTOFF64I 0x33
#define R_IA64_LTOFF64I	0x33
#define R_IA_64_PLTOFF22 0x3a
#define R_IA64_PLTOFF22	0x3a
#define R_IA_64_PLTOFF64I 0x3b
#define R_IA64_PLTOFF64I 0x3b
#define R_IA_64_PLTOFF64MSB 0x3e
#define R_IA64_PLTOFF64MSB 0x3e
#define R_IA_64_PLTOFF64LSB 0x3f
#define R_IA64_PLTOFF64LSB 0x3f
#define R_IA_64_FPTR64I	0x43
#define R_IA64_FPTR64I	0x43
#define R_IA_64_FPTR32MSB 0x44
#define R_IA64_FPTR32MSB 0x44
#define R_IA_64_FPTR32LSB 0x45
#define R_IA64_FPTR32LSB 0x45
#define R_IA_64_FPTR64MSB 0x46
#define R_IA64_FPTR64MSB 0x46
#define R_IA_64_FPTR64LSB 0x47
#define R_IA64_FPTR64LSB 0x47
#define R_IA_64_PCREL60B 0x48
#define R_IA_64_PCREL21B 0x49
#define R_IA64_PCREL21B	0x49
#define R_IA_64_PCREL21M 0x4a
#define R_IA64_PCREL21M	0x4a
#define R_IA_64_PCREL21F 0x4b
#define R_IA64_PCREL21F	0x4b
#define R_IA_64_PCREL32MSB 0x4c
#define R_IA64_PCREL32MSB 0x4c
#define R_IA_64_PCREL32LSB 0x4d
#define R_IA64_PCREL32LSB 0x4d
#define R_IA_64_PCREL64MSB 0x4e
#define R_IA64_PCREL64MSB 0x4e
#define R_IA_64_PCREL64LSB 0x4f
#define R_IA64_PCREL64LSB 0x4f
#define R_IA_64_LTOFF_FPTR22 0x52
#define R_IA64_LTOFF_FPTR22 0x52
#define R_IA_64_LTOFF_FPTR64I 0x53
#define R_IA64_LTOFF_FPTR64I 0x53
#define R_IA_64_LTOFF_FPTR32MSB 0x54
#define R_IA64_LTOFF_FPTR32MSB 0x54
#define R_IA_64_LTOFF_FPTR32LSB 0x55
#define R_IA64_LTOFF_FPTR32LSB 0x55
#define R_IA_64_LTOFF_FPTR64MSB 0x56
#define R_IA64_LTOFF_FPTR64MSB 0x56
#define R_IA_64_LTOFF_FPTR64LSB 0x57
#define R_IA64_LTOFF_FPTR64LSB 0x57
#define R_IA_64_SEGREL32MSB 0x5c
#define R_IA64_SEGREL32MSB 0x5c
#define R_IA_64_SEGREL32LSB 0x5d
#define R_IA64_SEGREL32LSB 0x5d
#define R_IA_64_SEGREL64MSB 0x5e
#define R_IA64_SEGREL64MSB 0x5e
#define R_IA_64_SEGREL64LSB 0x5f
#define R_IA64_SEGREL64LSB 0x5f
#define R_IA_64_SECREL32MSB 0x64
#define R_IA64_SECREL32MSB 0x64
#define R_IA_64_SECREL32LSB 0x65
#define R_IA64_SECREL32LSB 0x65
#define R_IA_64_SECREL64MSB 0x66
#define R_IA64_SECREL64MSB 0x66
#define R_IA_64_SECREL64LSB 0x67
#define R_IA64_SECREL64LSB 0x67
#define R_IA_64_REL32MSB 0x6c
#define R_IA64_REL32MSB	0x6c
#define R_IA_64_REL32LSB 0x6d
#define R_IA64_REL32LSB	0x6d
#define R_IA_64_REL64MSB 0x6e
#define R_IA64_REL64MSB	0x6e
#define R_IA_64_REL64LSB 0x6f
#define R_IA64_REL64LSB	0x6f
#define R_IA_64_LTV32MSB 0x74
#define R_IA64_LTV32MSB	0x74
#define R_IA_64_LTV32LSB 0x75
#define R_IA64_LTV32LSB	0x75
#define R_IA_64_LTV64MSB 0x76
#define R_IA64_LTV64MSB	0x76
#define R_IA_64_LTV64LSB 0x77
#define R_IA64_LTV64LSB	0x77
#define R_IA_64_PCREL21BI 0x79
#define R_IA_64_PCREL22	0x7A
#define R_IA_64_PCREL64I 0x7B
#define R_IA_64_IPLTMSB	0x80
#define R_IA64_IPLTMSB	0x80
#define R_IA_64_IPLTLSB	0x81
#define R_IA64_IPLTLSB	0x81
#define R_IA_64_SUB	0x85
#define R_IA64_SUB	0x85
#define R_IA_64_LTOFF22X 0x86
#define R_IA64_LTOFF22X	0x86
#define R_IA_64_LDXMOV	0x87
#define R_IA64_LDXMOV	0x87
#define R_IA_64_TPREL14	0x91
#define R_IA64_TPREL14	0x91
#define R_IA_64_TPREL22	0x92
#define R_IA64_TPREL22	0x92
#define R_IA_64_TPREL64I 0x93
#define R_IA64_TPREL64I	0x93
#define R_IA_64_TPREL64MSB 0x96
#define R_IA64_TPREL64MSB 0x96
#define R_IA_64_TPREL64LSB 0x97
#define R_IA64_TPREL64LSB 0x97
#define R_IA_64_LTOFF_TPREL22 0x9A
#define R_IA64_LTOFF_TPREL22 0x9A
#define R_IA_64_DTPMOD64MSB 0xA6
#define R_IA64_DTPMOD64MSB 0xA6
#define R_IA_64_DTPMOD64LSB 0xA7
#define R_IA64_DTPMOD64LSB 0xA7
#define R_IA_64_LTOFF_DTPMOD22 0xAA
#define R_IA64_LTOFF_DTPMOD22 0xAA
#define R_IA_64_DTPREL14 0xB1
#define R_IA64_DTPREL14	0xB1
#define R_IA_64_DTPREL22 0xB2
#define R_IA64_DTPREL22	0xB2
#define R_IA_64_DTPREL64I 0xB3
#define R_IA64_DTPREL64I 0xB3
#define R_IA_64_DTPREL32MSB 0xB4
#define R_IA64_DTPREL32MSB 0xB4
#define R_IA_64_DTPREL32LSB 0xB5
#define R_IA64_DTPREL32LSB 0xB5
#define R_IA_64_DTPREL64MSB 0xB6
#define R_IA64_DTPREL64MSB 0xB6
#define R_IA_64_DTPREL64LSB 0xB7
#define R_IA64_DTPREL64LSB 0xB7
#define R_IA_64_LTOFF_DTPREL22 0xBA
#define R_IA64_LTOFF_DTPREL22 0xBA


#define R_LARCH_NONE	0
#define R_LARCH_32	1
#define R_LARCH_64	2
#define R_LARCH_RELATIVE 3
#define R_LARCH_COPY	4
#define R_LARCH_JUMP_SLOT 5
#define R_LARCH_TLS_DTPMOD32 6
#define R_LARCH_TLS_DTPMOD64 7
#define R_LARCH_TLS_DTPREL32 8
#define R_LARCH_TLS_DTPREL64 9
#define R_LARCH_TLS_TPREL32 10
#define R_LARCH_TLS_TPREL64 11
#define R_LARCH_IRELATIVE 12
#define R_LARCH_TLS_DESC32 13
#define R_LARCH_TLS_DESC64 14
#define R_LARCH_MARK_LA	20
#define R_LARCH_MARK_PCREL 21
#define R_LARCH_SOP_PUSH_PCREL 22
#define R_LARCH_SOP_PUSH_ABSOLUTE 23
#define R_LARCH_SOP_PUSH_DUP 24
#define R_LARCH_SOP_PUSH_GPREL 25
#define R_LARCH_SOP_PUSH_TLS_TPREL 26
#define R_LARCH_SOP_PUSH_TLS_GOT 27
#define R_LARCH_SOP_PUSH_TLS_GD 28
#define R_LARCH_SOP_PUSH_PLT_PCREL 29
#define R_LARCH_SOP_ASSERT 30
#define R_LARCH_SOP_NOT	31
#define R_LARCH_SOP_SUB	32
#define R_LARCH_SOP_SL	33
#define R_LARCH_SOP_SR	34
#define R_LARCH_SOP_ADD	35
#define R_LARCH_SOP_AND	36
#define R_LARCH_SOP_IF_ELSE 37
#define R_LARCH_SOP_POP_32_S_10_5 38
#define R_LARCH_SOP_POP_32_U_10_12 39
#define R_LARCH_SOP_POP_32_S_10_12 40
#define R_LARCH_SOP_POP_32_S_10_16 41
#define R_LARCH_SOP_POP_32_S_10_16_S2 42
#define R_LARCH_SOP_POP_32_S_5_20 43
#define R_LARCH_SOP_POP_32_S_0_5_10_16_S2 44
#define R_LARCH_SOP_POP_32_S_0_10_10_16_S2 45
#define R_LARCH_SOP_POP_32_U 46
#define R_LARCH_ADD8	47
#define R_LARCH_ADD16	48
#define R_LARCH_ADD24	49
#define R_LARCH_ADD32	50
#define R_LARCH_ADD64	51
#define R_LARCH_SUB8	52
#define R_LARCH_SUB16	53
#define R_LARCH_SUB24	54
#define R_LARCH_SUB32	55
#define R_LARCH_SUB64	56
#define R_LARCH_GNU_VTINHERIT 57
#define R_LARCH_GNU_VTENTRY 58
#define R_LARCH_B16	64
#define R_LARCH_B21	65
#define R_LARCH_B26	66
#define R_LARCH_ABS_HI20 67
#define R_LARCH_ABS_LO12 68
#define R_LARCH_ABS64_LO20 69
#define R_LARCH_ABS64_HI12 70
#define R_LARCH_PCALA_HI20 71
#define R_LARCH_PCALA_LO12 72
#define R_LARCH_PCALA64_LO20 73
#define R_LARCH_PCALA64_HI12 74
#define R_LARCH_GOT_PC_HI20 75
#define R_LARCH_GOT_PC_LO12 76
#define R_LARCH_GOT64_PC_LO20 77
#define R_LARCH_GOT64_PC_HI12 78
#define R_LARCH_GOT_HI20 79
#define R_LARCH_GOT_LO12 80
#define R_LARCH_GOT64_LO20 81
#define R_LARCH_GOT64_HI12 82
#define R_LARCH_TLS_LE_HI20 83
#define R_LARCH_TLS_LE_LO12 84
#define R_LARCH_TLS_LE64_LO20 85
#define R_LARCH_TLS_LE64_HI12 86
#define R_LARCH_TLS_IE_PC_HI20 87
#define R_LARCH_TLS_IE_PC_LO12 88
#define R_LARCH_TLS_IE64_PC_LO20 89
#define R_LARCH_TLS_IE64_PC_HI12 90
#define R_LARCH_TLS_IE_HI20 91
#define R_LARCH_TLS_IE_LO12 92
#define R_LARCH_TLS_IE64_LO20 93
#define R_LARCH_TLS_IE64_HI12 94
#define R_LARCH_TLS_LD_PC_HI20 95
#define R_LARCH_TLS_LD_HI20 96
#define R_LARCH_TLS_GD_PC_HI20 97
#define R_LARCH_TLS_GD_HI20 98
#define R_LARCH_32_PCREL 99
#define R_LARCH_RELAX	100
#define R_LARCH_ALIGN	102
#define R_LARCH_PCREL20_S2 103
#define R_LARCH_ADD6	105
#define R_LARCH_SUB6	106
#define R_LARCH_ADD_ULEB128 107
#define R_LARCH_SUB_ULEB128 108
#define R_LARCH_64_PCREL 109
#define R_LARCH_CALL36	110
#define R_LARCH_TLS_DESC_PC_HI20 111
#define R_LARCH_TLS_DESC_PC_LO12 112
#define R_LARCH_TLS_DESC64_PC_LO20 113
#define R_LARCH_TLS_DESC64_PC_HI12 114
#define R_LARCH_TLS_DESC_HI20 115
#define R_LARCH_TLS_DESC_LO12 116
#define R_LARCH_TLS_DESC64_LO20 117
#define R_LARCH_TLS_DESC64_HI12 118
#define R_LARCH_TLS_DESC_LD 119
#define R_LARCH_TLS_DESC_CALL 120
#define R_LARCH_TLS_LE_HI20_R 121
#define R_LARCH_TLS_LE_ADD_R 122
#define R_LARCH_TLS_LE_LO12_R 123
#define R_LARCH_TLS_LD_PCREL20_S2 124
#define R_LARCH_TLS_GD_PCREL20_S2 125
#define R_LARCH_TLS_DESC_PCREL20_S2 126


#define R_MIPS_NONE	0
#define R_MIPS_16	1
#define R_MIPS_32	2
#define R_MIPS_REL32	3
#define R_MIPS_26	4
#define R_MIPS_HI16	5
#define R_MIPS_LO16	6
#define R_MIPS_GPREL16	7
#define R_MIPS_LITERAL	8
#define R_MIPS_GOT16	9
#define R_MIPS_PC16	10
#define R_MIPS_CALL16	11
#define R_MIPS_GPREL32	12
#define R_MIPS_SHIFT5	16
#define R_MIPS_SHIFT6	17
#define R_MIPS_64	18
#define R_MIPS_GOT_DISP	19
#define R_MIPS_GOT_PAGE	20
#define R_MIPS_GOT_OFST	21
#define R_MIPS_GOT_HI16	22
#define R_MIPS_GOT_LO16	23
#define R_MIPS_SUB	24
#define R_MIPS_CALLHI16	30
#define R_MIPS_CALLLO16	31
#define R_MIPS_JALR	37
#define R_MIPS_TLS_DTPMOD32 38
#define R_MIPS_TLS_DTPREL32 39
#define R_MIPS_TLS_DTPMOD64 40
#define R_MIPS_TLS_DTPREL64 41
#define R_MIPS_TLS_GD	42
#define R_MIPS_TLS_LDM	43
#define R_MIPS_TLS_DTPREL_HI16 44
#define R_MIPS_TLS_DTPREL_LO16 45
#define R_MIPS_TLS_GOTTPREL 46
#define R_MIPS_TLS_TPREL32 47
#define R_MIPS_TLS_TPREL64 48
#define R_MIPS_TLS_TPREL_HI16 49
#define R_MIPS_TLS_TPREL_LO16 50


#define R_PPC_NONE	0
#define R_PPC_ADDR32	1
#define R_PPC_ADDR24	2
#define R_PPC_ADDR16	3
#define R_PPC_ADDR16_LO	4
#define R_PPC_ADDR16_HI	5
#define R_PPC_ADDR16_HA	6
#define R_PPC_ADDR14	7
#define R_PPC_ADDR14_BRTAKEN 8
#define R_PPC_ADDR14_BRNTAKEN 9
#define R_PPC_REL24	10
#define R_PPC_REL14	11
#define R_PPC_REL14_BRTAKEN 12
#define R_PPC_REL14_BRNTAKEN 13
#define R_PPC_GOT16	14
#define R_PPC_GOT16_LO	15
#define R_PPC_GOT16_HI	16
#define R_PPC_GOT16_HA	17
#define R_PPC_PLTREL24	18
#define R_PPC_COPY	19
#define R_PPC_GLOB_DAT	20
#define R_PPC_JMP_SLOT	21
#define R_PPC_RELATIVE	22
#define R_PPC_LOCAL24PC	23
#define R_PPC_UADDR32	24
#define R_PPC_UADDR16	25
#define R_PPC_REL32	26
#define R_PPC_PLT32	27
#define R_PPC_PLTREL32	28
#define R_PPC_PLT16_LO	29
#define R_PPC_PLT16_HI	30
#define R_PPC_PLT16_HA	31
#define R_PPC_SDAREL16	32
#define R_PPC_SECTOFF	33
#define R_PPC_SECTOFF_LO 34
#define R_PPC_SECTOFF_HI 35
#define R_PPC_SECTOFF_HA 36
#define R_PPC_ADDR30	37
#define R_PPC_TLS	67
#define R_PPC_DTPMOD32	68
#define R_PPC_TPREL16	69
#define R_PPC_TPREL16_LO 70
#define R_PPC_TPREL16_HI 71
#define R_PPC_TPREL16_HA 72
#define R_PPC_TPREL32	73
#define R_PPC_DTPREL16	74
#define R_PPC_DTPREL16_LO 75
#define R_PPC_DTPREL16_HI 76
#define R_PPC_DTPREL16_HA 77
#define R_PPC_DTPREL32	78
#define R_PPC_GOT_TLSGD16 79
#define R_PPC_GOT_TLSGD16_LO 80
#define R_PPC_GOT_TLSGD16_HI 81
#define R_PPC_GOT_TLSGD16_HA 82
#define R_PPC_GOT_TLSLD16 83
#define R_PPC_GOT_TLSLD16_LO 84
#define R_PPC_GOT_TLSLD16_HI 85
#define R_PPC_GOT_TLSLD16_HA 86
#define R_PPC_GOT_TPREL16 87
#define R_PPC_GOT_TPREL16_LO 88
#define R_PPC_GOT_TPREL16_HI 89
#define R_PPC_GOT_TPREL16_HA 90
#define R_PPC_GOT_DTPREL16 91
#define R_PPC_GOT_DTPREL16_LO 92
#define R_PPC_GOT_DTPREL16_HI 93
#define R_PPC_GOT_DTPREL16_HA 94
#define R_PPC_TLSGD	95
#define R_PPC_TLSLD	96
#define R_PPC_EMB_NADDR32 101
#define R_PPC_EMB_NADDR16 102
#define R_PPC_EMB_NADDR16_LO 103
#define R_PPC_EMB_NADDR16_HI 104
#define R_PPC_EMB_NADDR16_HA 105
#define R_PPC_EMB_SDAI16 106
#define R_PPC_EMB_SDA2I16 107
#define R_PPC_EMB_SDA2REL 108
#define R_PPC_EMB_SDA21	109
#define R_PPC_EMB_MRKREF 110
#define R_PPC_EMB_RELSEC16 111
#define R_PPC_EMB_RELST_LO 112
#define R_PPC_EMB_RELST_HI 113
#define R_PPC_EMB_RELST_HA 114
#define R_PPC_EMB_BIT_FLD 115
#define R_PPC_EMB_RELSDA 116


#define R_PPC64_NONE	0
#define R_PPC64_ADDR32	1
#define R_PPC64_ADDR24	2
#define R_PPC64_ADDR16	3
#define R_PPC64_ADDR16_LO 4
#define R_PPC64_ADDR16_HI 5
#define R_PPC64_ADDR16_HA 6
#define R_PPC64_ADDR14	7
#define R_PPC64_ADDR14_BRTAKEN 8
#define R_PPC64_ADDR14_BRNTAKEN 9
#define R_PPC64_REL24	10
#define R_PPC64_REL14	11
#define R_PPC64_REL14_BRTAKEN 12
#define R_PPC64_REL14_BRNTAKEN 13
#define R_PPC64_GOT16	14
#define R_PPC64_GOT16_LO 15
#define R_PPC64_GOT16_HI 16
#define R_PPC64_GOT16_HA 17
#define R_PPC64_COPY	19
#define R_PPC64_GLOB_DAT 20
#define R_PPC64_JMP_SLOT 21
#define R_PPC64_RELATIVE 22
#define R_PPC64_UADDR32	24
#define R_PPC64_UADDR16	25
#define R_PPC64_REL32	26
#define R_PPC64_PLT32	27
#define R_PPC64_PLTREL32 28
#define R_PPC64_PLT16_LO 29
#define R_PPC64_PLT16_HI 30
#define R_PPC64_PLT16_HA 31
#define R_PPC64_SECTOFF	33
#define R_PPC64_SECTOFF_LO 34
#define R_PPC64_SECTOFF_HI 35
#define R_PPC64_SECTOFF_HA 36
#define R_PPC64_ADDR30	37
#define R_PPC64_ADDR64	38
#define R_PPC64_ADDR16_HIGHER 39
#define R_PPC64_ADDR16_HIGHERA 40
#define R_PPC64_ADDR16_HIGHEST 41
#define R_PPC64_ADDR16_HIGHESTA 42
#define R_PPC64_UADDR64	43
#define R_PPC64_REL64	44
#define R_PPC64_PLT64	45
#define R_PPC64_PLTREL64 46
#define R_PPC64_TOC16	47
#define R_PPC64_TOC16_LO 48
#define R_PPC64_TOC16_HI 49
#define R_PPC64_TOC16_HA 50
#define R_PPC64_TOC	51
#define R_PPC64_PLTGOT16 52
#define R_PPC64_PLTGOT16_LO 53
#define R_PPC64_PLTGOT16_HI 54
#define R_PPC64_PLTGOT16_HA 55
#define R_PPC64_ADDR16_DS 56
#define R_PPC64_ADDR16_LO_DS 57
#define R_PPC64_GOT16_DS 58
#define R_PPC64_GOT16_LO_DS 59
#define R_PPC64_PLT16_LO_DS 60
#define R_PPC64_SECTOFF_DS 61
#define R_PPC64_SECTOFF_LO_DS 62
#define R_PPC64_TOC16_DS 63
#define R_PPC64_TOC16_LO_DS 64
#define R_PPC64_PLTGOT16_DS 65
#define R_PPC64_PLTGOT16_LO_DS 66
#define R_PPC64_TLS	67
#define R_PPC64_DTPMOD64 68
#define R_PPC64_TPREL16	69
#define R_PPC64_TPREL16_LO 60
#define R_PPC64_TPREL16_HI 71
#define R_PPC64_TPREL16_HA 72
#define R_PPC64_TPREL64	73
#define R_PPC64_DTPREL16 74
#define R_PPC64_DTPREL16_LO 75
#define R_PPC64_DTPREL16_HI 76
#define R_PPC64_DTPREL16_HA 77
#define R_PPC64_DTPREL64 78
#define R_PPC64_GOT_TLSGD16 79
#define R_PPC64_GOT_TLSGD16_LO 80
#define R_PPC64_GOT_TLSGD16_HI 81
#define R_PPC64_GOT_TLSGD16_HA 82
#define R_PPC64_GOT_TLSLD16 83
#define R_PPC64_GOT_TLSLD16_LO 84
#define R_PPC64_GOT_TLSLD16_HI 85
#define R_PPC64_GOT_TLSLD16_HA 86
#define R_PPC64_GOT_TPREL16_DS 87
#define R_PPC64_GOT_TPREL16_LO_DS 88
#define R_PPC64_GOT_TPREL16_HI 89
#define R_PPC64_GOT_TPREL16_HA 90
#define R_PPC64_GOT_DTPREL16_DS 91
#define R_PPC64_GOT_DTPREL16_LO_DS 92
#define R_PPC64_GOT_DTPREL16_HI 93
#define R_PPC64_GOT_DTPREL16_HA 94
#define R_PPC64_TPREL16_DS 95
#define R_PPC64_TPREL16_LO_DS 96
#define R_PPC64_TPREL16_HIGHER 97
#define R_PPC64_TPREL16_HIGHERA 98
#define R_PPC64_TPREL16_HIGHEST 99
#define R_PPC64_TPREL16_HIGHESTA 100
#define R_PPC64_DTPREL16_DS 101
#define R_PPC64_DTPREL16_LO_DS 102
#define R_PPC64_DTPREL16_HIGHER 103
#define R_PPC64_DTPREL16_HIGHERA 104
#define R_PPC64_DTPREL16_HIGHEST 105
#define R_PPC64_DTPREL16_HIGHESTA 106
#define R_PPC64_TLSGD	107
#define R_PPC64_TLSLD	108


#define R_RISCV_NONE	0
#define R_RISCV_32	1
#define R_RISCV_64	2
#define R_RISCV_RELATIVE 3
#define R_RISCV_COPY	4
#define R_RISCV_JUMP_SLOT 5
#define R_RISCV_TLS_DTPMOD32 6
#define R_RISCV_TLS_DTPMOD64 7
#define R_RISCV_TLS_DTPREL32 8
#define R_RISCV_TLS_DTPREL64 9
#define R_RISCV_TLS_TPREL32 10
#define R_RISCV_TLS_TPREL64 11
#define R_RISCV_BRANCH	16
#define R_RISCV_JAL	17
#define R_RISCV_CALL	18
#define R_RISCV_CALL_PLT 19
#define R_RISCV_GOT_HI20 20
#define R_RISCV_TLS_GOT_HI20 21
#define R_RISCV_TLS_GD_HI20 22
#define R_RISCV_PCREL_HI20 23
#define R_RISCV_PCREL_LO12_I 24
#define R_RISCV_PCREL_LO12_S 25
#define R_RISCV_HI20	26
#define R_RISCV_LO12_I	27
#define R_RISCV_LO12_S	28
#define R_RISCV_TPREL_HI20 29
#define R_RISCV_TPREL_LO12_I 30
#define R_RISCV_TPREL_LO12_S 31
#define R_RISCV_TPREL_ADD 32
#define R_RISCV_ADD8	33
#define R_RISCV_ADD16	34
#define R_RISCV_ADD32	35
#define R_RISCV_ADD64	36
#define R_RISCV_SUB8	37
#define R_RISCV_SUB16	38
#define R_RISCV_SUB32	39
#define R_RISCV_SUB64	40
#define R_RISCV_GNU_VTINHERIT 41
#define R_RISCV_GNU_VTENTRY 42
#define R_RISCV_ALIGN	43
#define R_RISCV_RVC_BRANCH 44
#define R_RISCV_RVC_JUMP 45
#define R_RISCV_RVC_LUI	46
#define R_RISCV_GPREL_I	47
#define R_RISCV_GPREL_S	48
#define R_RISCV_TPREL_I	49
#define R_RISCV_TPREL_S	50
#define R_RISCV_RELAX	51
#define R_RISCV_SUB6	52
#define R_RISCV_SET6	53
#define R_RISCV_SET8	54
#define R_RISCV_SET16	55
#define R_RISCV_SET32	56
#define R_RISCV_32_PCREL 57
#define R_RISCV_IRELATIVE 58


#define R_SPARC_NONE	0
#define R_SPARC_8	1
#define R_SPARC_16	2
#define R_SPARC_32	3
#define R_SPARC_DISP8	4
#define R_SPARC_DISP16	5
#define R_SPARC_DISP32	6
#define R_SPARC_WDISP30	7
#define R_SPARC_WDISP22	8
#define R_SPARC_HI22	9
#define R_SPARC_22	10
#define R_SPARC_13	11
#define R_SPARC_LO10	12
#define R_SPARC_GOT10	13
#define R_SPARC_GOT13	14
#define R_SPARC_GOT22	15
#define R_SPARC_PC10	16
#define R_SPARC_PC22	17
#define R_SPARC_WPLT30	18
#define R_SPARC_COPY	19
#define R_SPARC_GLOB_DAT 20
#define R_SPARC_JMP_SLOT 21
#define R_SPARC_RELATIVE 22
#define R_SPARC_UA32	23
#define R_SPARC_PLT32	24
#define R_SPARC_HIPLT22	25
#define R_SPARC_LOPLT10	26
#define R_SPARC_PCPLT32	27
#define R_SPARC_PCPLT22	28
#define R_SPARC_PCPLT10	29
#define R_SPARC_10	30
#define R_SPARC_11	31
#define R_SPARC_64	32
#define R_SPARC_OLO10	33
#define R_SPARC_HH22	34
#define R_SPARC_HM10	35
#define R_SPARC_LM22	36
#define R_SPARC_PC_HH22	37
#define R_SPARC_PC_HM10	38
#define R_SPARC_PC_LM22	39
#define R_SPARC_WDISP16	40
#define R_SPARC_WDISP19	41
#define R_SPARC_GLOB_JMP 42
#define R_SPARC_7	43
#define R_SPARC_5	44
#define R_SPARC_6	45
#define R_SPARC_DISP64	46
#define R_SPARC_PLT64	47
#define R_SPARC_HIX22	48
#define R_SPARC_LOX10	49
#define R_SPARC_H44	50
#define R_SPARC_M44	51
#define R_SPARC_L44	52
#define R_SPARC_REGISTER 53
#define R_SPARC_UA64	54
#define R_SPARC_UA16	55
#define R_SPARC_TLS_GD_HI22 56
#define R_SPARC_TLS_GD_LO10 57
#define R_SPARC_TLS_GD_ADD 58
#define R_SPARC_TLS_GD_CALL 59
#define R_SPARC_TLS_LDM_HI22 60
#define R_SPARC_TLS_LDM_LO10 61
#define R_SPARC_TLS_LDM_ADD 62
#define R_SPARC_TLS_LDM_CALL 63
#define R_SPARC_TLS_LDO_HIX22 64
#define R_SPARC_TLS_LDO_LOX10 65
#define R_SPARC_TLS_LDO_ADD 66
#define R_SPARC_TLS_IE_HI22 67
#define R_SPARC_TLS_IE_LO10 68
#define R_SPARC_TLS_IE_LD 69
#define R_SPARC_TLS_IE_LDX 70
#define R_SPARC_TLS_IE_ADD 71
#define R_SPARC_TLS_LE_HIX22 72
#define R_SPARC_TLS_LE_LOX10 73
#define R_SPARC_TLS_DTPMOD32 74
#define R_SPARC_TLS_DTPMOD64 75
#define R_SPARC_TLS_DTPOFF32 76
#define R_SPARC_TLS_DTPOFF64 77
#define R_SPARC_TLS_TPOFF32 78
#define R_SPARC_TLS_TPOFF64 79
#define R_SPARC_GOTDATA_HIX22 80
#define R_SPARC_GOTDATA_LOX10 81
#define R_SPARC_GOTDATA_OP_HIX22 82
#define R_SPARC_GOTDATA_OP_LOX10 83
#define R_SPARC_GOTDATA_OP 84
#define R_SPARC_H34	85


#define R_VAX_NONE	0
#define R_VAX_32	1
#define R_VAX_16	2
#define R_VAX_8		3
#define R_VAX_PC32	4
#define R_VAX_PC16	5
#define R_VAX_PC8	6
#define R_VAX_GOT32	7
#define R_VAX_PLT32	13
#define R_VAX_COPY	19
#define R_VAX_GLOB_DAT	20
#define R_VAX_JMP_SLOT	21
#define R_VAX_RELATIVE	22


#define R_X86_64_NONE	0
#define R_X86_64_64	1
#define R_X86_64_PC32	2
#define R_X86_64_GOT32	3
#define R_X86_64_PLT32	4
#define R_X86_64_COPY	5
#define R_X86_64_GLOB_DAT 6
#define R_X86_64_JUMP_SLOT 7
#define R_X86_64_RELATIVE 8
#define R_X86_64_GOTPCREL 9
#define R_X86_64_32	10
#define R_X86_64_32S	11
#define R_X86_64_16	12
#define R_X86_64_PC16	13
#define R_X86_64_8	14
#define R_X86_64_PC8	15
#define R_X86_64_DTPMOD64 16
#define R_X86_64_DTPOFF64 17
#define R_X86_64_TPOFF64 18
#define R_X86_64_TLSGD	19
#define R_X86_64_TLSLD	20
#define R_X86_64_DTPOFF32 21
#define R_X86_64_GOTTPOFF 22
#define R_X86_64_TPOFF32 23
#define R_X86_64_PC64	24
#define R_X86_64_GOTOFF64 25
#define R_X86_64_GOTPC32 26
#define R_X86_64_GOT64	27
#define R_X86_64_GOTPCREL64 28
#define R_X86_64_GOTPC64 29
#define R_X86_64_GOTPLT64 30
#define R_X86_64_PLTOFF64 31
#define R_X86_64_SIZE32	32
#define R_X86_64_SIZE64	33
#define R_X86_64_GOTPC32_TLSDESC 34
#define R_X86_64_TLSDESC_CALL 35
#define R_X86_64_TLSDESC 36
#define R_X86_64_IRELATIVE 37
#define R_X86_64_RELATIVE64 38
#define R_X86_64_PC32_BND 39
#define R_X86_64_PLT32_BND 40
#define R_X86_64_GOTPCRELX 41
#define R_X86_64_REX_GOTPCRELX 42



/*
 * MIPS ABI related.
 */

#define E_MIPS_ABI_O32	0x00001000 /* MIPS 32 bit ABI (UCODE) */
#define E_MIPS_ABI_O64	0x00002000 /* UCODE MIPS 64 bit ABI */
#define E_MIPS_ABI_EABI32 0x00003000 /* Embedded ABI for 32-bit */
#define E_MIPS_ABI_EABI64 0x00004000 /* Embedded ABI for 64-bit */


/**
 ** ELF Types.
 **/

typedef uint32_t	Elf32_Addr;	/* Program address. */
typedef uint8_t		Elf32_Byte;	/* Unsigned tiny integer. */
typedef uint16_t	Elf32_Half;	/* Unsigned medium integer. */
typedef uint32_t	Elf32_Off;	/* File offset. */
typedef uint16_t	Elf32_Section;	/* Section index. */
typedef int32_t		Elf32_Sword;	/* Signed integer. */
typedef uint32_t	Elf32_Word;	/* Unsigned integer. */
typedef uint64_t	Elf32_Lword;	/* Unsigned long integer. */

typedef uint64_t	Elf64_Addr;	/* Program address. */
typedef uint8_t		Elf64_Byte;	/* Unsigned tiny integer. */
typedef uint16_t	Elf64_Half;	/* Unsigned medium integer. */
typedef uint64_t	Elf64_Off;	/* File offset. */
typedef uint16_t	Elf64_Section;	/* Section index. */
typedef int32_t		Elf64_Sword;	/* Signed integer. */
typedef uint32_t	Elf64_Word;	/* Unsigned integer. */
typedef uint64_t	Elf64_Lword;	/* Unsigned long integer. */
typedef uint64_t	Elf64_Xword;	/* Unsigned long integer. */
typedef int64_t		Elf64_Sxword;	/* Signed long integer. */


/*
 * Capability descriptors.
 */

/* 32-bit capability descriptor. */
typedef struct {
	Elf32_Word	c_tag;	     /* Type of entry. */
	union {
		Elf32_Word	c_val; /* Integer value. */
		Elf32_Addr	c_ptr; /* Pointer value. */
	} c_un;
} Elf32_Cap;

/* 64-bit capability descriptor. */
typedef struct {
	Elf64_Xword	c_tag;	     /* Type of entry. */
	union {
		Elf64_Xword	c_val; /* Integer value. */
		Elf64_Addr	c_ptr; /* Pointer value. */
	} c_un;
} Elf64_Cap;

/*
 * MIPS .conflict section entries.
 */

/* 32-bit entry. */
typedef struct {
	Elf32_Addr	c_index;
} Elf32_Conflict;

/* 64-bit entry. */
typedef struct {
	Elf64_Addr	c_index;
} Elf64_Conflict;

/*
 * Dynamic section entries.
 */

/* 32-bit entry. */
typedef struct {
	Elf32_Sword	d_tag;	     /* Type of entry. */
	union {
		Elf32_Word	d_val; /* Integer value. */
		Elf32_Addr	d_ptr; /* Pointer value. */
	} d_un;
} Elf32_Dyn;

/* 64-bit entry. */
typedef struct {
	Elf64_Sxword	d_tag;	     /* Type of entry. */
	union {
		Elf64_Xword	d_val; /* Integer value. */
		Elf64_Addr	d_ptr; /* Pointer value; */
	} d_un;
} Elf64_Dyn;


/*
 * The executable header (EHDR).
 */

/* 32 bit EHDR. */
typedef struct {
	unsigned char   e_ident[EI_NIDENT]; /* ELF identification. */
	Elf32_Half      e_type;	     /* Object file type (ET_*). */
	Elf32_Half      e_machine;   /* Machine type (EM_*). */
	Elf32_Word      e_version;   /* File format version (EV_*). */
	Elf32_Addr      e_entry;     /* Start address. */
	Elf32_Off       e_phoff;     /* File offset to the PHDR table. */
	Elf32_Off       e_shoff;     /* File offset to the SHDRheader. */
	Elf32_Word      e_flags;     /* Flags (EF_*). */
	Elf32_Half      e_ehsize;    /* Elf header size in bytes. */
	Elf32_Half      e_phentsize; /* PHDR table entry size in bytes. */
	Elf32_Half      e_phnum;     /* Number of PHDR entries. */
	Elf32_Half      e_shentsize; /* SHDR table entry size in bytes. */
	Elf32_Half      e_shnum;     /* Number of SHDR entries. */
	Elf32_Half      e_shstrndx;  /* Index of section name string table. */
} Elf32_Ehdr;


/* 64 bit EHDR. */
typedef struct {
	unsigned char   e_ident[EI_NIDENT]; /* ELF identification. */
	Elf64_Half      e_type;	     /* Object file type (ET_*). */
	Elf64_Half      e_machine;   /* Machine type (EM_*). */
	Elf64_Word      e_version;   /* File format version (EV_*). */
	Elf64_Addr      e_entry;     /* Start address. */
	Elf64_Off       e_phoff;     /* File offset to the PHDR table. */
	Elf64_Off       e_shoff;     /* File offset to the SHDRheader. */
	Elf64_Word      e_flags;     /* Flags (EF_*). */
	Elf64_Half      e_ehsize;    /* Elf header size in bytes. */
	Elf64_Half      e_phentsize; /* PHDR table entry size in bytes. */
	Elf64_Half      e_phnum;     /* Number of PHDR entries. */
	Elf64_Half      e_shentsize; /* SHDR table entry size in bytes. */
	Elf64_Half      e_shnum;     /* Number of SHDR entries. */
	Elf64_Half      e_shstrndx;  /* Index of section name string table. */
} Elf64_Ehdr;


/*
 * Shared object information.
 */

/* 32-bit entry. */
typedef struct {
	Elf32_Word l_name;	     /* The name of a shared object. */
	Elf32_Word l_time_stamp;     /* 32-bit timestamp. */
	Elf32_Word l_checksum;	     /* Checksum of visible symbols, sizes. */
	Elf32_Word l_version;	     /* Interface version string index. */
	Elf32_Word l_flags;	     /* Flags (LL_*). */
} Elf32_Lib;

/* 64-bit entry. */
typedef struct {
	Elf64_Word l_name;	     /* The name of a shared object. */
	Elf64_Word l_time_stamp;     /* 32-bit timestamp. */
	Elf64_Word l_checksum;	     /* Checksum of visible symbols, sizes. */
	Elf64_Word l_version;	     /* Interface version string index. */
	Elf64_Word l_flags;	     /* Flags (LL_*). */
} Elf64_Lib;


#define LL_NONE		0 /* no flags */
#define LL_EXACT_MATCH	0x1 /* require an exact match */
#define LL_IGNORE_INT_VER 0x2 /* ignore version incompatibilities */
#define LL_REQUIRE_MINOR 0x4
#define LL_EXPORTS	0x8
#define LL_DELAY_LOAD	0x10
#define LL_DELTA	0x20


/*
 * Note tags
 */

#define NT_ABI_TAG	1 /* Tag indicating the ABI */
#define NT_GNU_HWCAP	2 /* Hardware capabilities */
#define NT_GNU_BUILD_ID	3 /* Build id */
#define NT_GNU_GOLD_VERSION 4 /* Version number of the GNU gold linker */
#define NT_PRSTATUS	1 /* Process status */
#define NT_FPREGSET	2 /* Floating point information */
#define NT_PRPSINFO	3 /* Process information */
#define NT_AUXV		6 /* Auxiliary vector */
#define NT_PRXFPREG	0x46E62B7FU /* Linux user_xfpregs structure */
#define NT_PSTATUS	10 /* Linux process status */
#define NT_FPREGS	12 /* Linux floating point regset */
#define NT_PSINFO	13 /* Linux process information */
#define NT_LWPSTATUS	16 /* Linux lwpstatus_t type */
#define NT_LWPSINFO	17 /* Linux lwpinfo_t type */
#define NT_FREEBSD_NOINIT_TAG 2 /* FreeBSD no .init tag */
#define NT_FREEBSD_ARCH_TAG 3 /* FreeBSD arch tag */
#define NT_FREEBSD_FEATURE_CTL 4 /* FreeBSD feature control */

/* Aliases for the ABI tag. */

#define NT_FREEBSD_ABI_TAG NT_ABI_TAG
#define NT_GNU_ABI_TAG	NT_ABI_TAG
#define NT_NETBSD_IDENT	NT_ABI_TAG
#define NT_OPENBSD_IDENT NT_ABI_TAG


/*
 * Note descriptors.
 */

typedef	struct {
	uint32_t	n_namesz;    /* Length of note's name. */
	uint32_t	n_descsz;    /* Length of note's value. */
	uint32_t	n_type;	     /* Type of note. */
} Elf_Note;

typedef Elf_Note Elf32_Nhdr;	     /* 32-bit note header. */
typedef Elf_Note Elf64_Nhdr;	     /* 64-bit note header. */

/*
 * MIPS ELF options descriptor header.
 */

typedef struct {
	Elf64_Byte	kind;        /* Type of options. */
	Elf64_Byte     	size;	     /* Size of option descriptor. */
	Elf64_Half	section;     /* Index of section affected. */
	Elf64_Word	info;        /* Kind-specific information. */
} Elf_Options;

/*
 * Option kinds.
 */

#define ODK_NULL	0 /* undefined */
#define ODK_REGINFO	1 /* register usage info */
#define ODK_EXCEPTIONS	2 /* exception processing info */
#define ODK_PAD		3 /* section padding */
#define ODK_HWPATCH	4 /* hardware patch applied */
#define ODK_FILL	5 /* fill value used by linker */
#define ODK_TAGS	6 /* reserved space for tools */
#define ODK_HWAND	7 /* hardware AND patch applied */
#define ODK_HWOR	8 /* hardware OR patch applied */
#define ODK_GP_GROUP	9 /* GP group to use for text/data sections */
#define ODK_IDENT	10 /* ID information */
#define ODK_PAGESIZE	11 /* page size information */


/*
 * ODK_EXCEPTIONS info field masks.
 */

#define OEX_FPU_MIN	0x0000001FU /* minimum FPU exception which must be enabled */
#define OEX_FPU_MAX	0x00001F00U /* maximum FPU exception which can be enabled */
#define OEX_PAGE0	0x00010000U /* page zero must be mapped */
#define OEX_SMM		0x00020000U /* run in sequential memory mode */
#define OEX_PRECISEFP	0x00040000U /* run in precise FP exception mode */
#define OEX_DISMISS	0x00080000U /* dismiss invalid address traps */


/*
 * ODK_PAD info field masks.
 */

#define OPAD_PREFIX	0x0001
#define OPAD_POSTFIX	0x0002
#define OPAD_SYMBOL	0x0004


/*
 * ODK_HWPATCH info field masks and ODK_HWAND/ODK_HWOR info field
 * and hwp_flags[12] masks.
 */

#define OHW_R4KEOP	0x00000001U /* patch for R4000 branch at end-of-page bug */
#define OHW_R8KPFETCH	0x00000002U /* R8000 prefetch bug may occur */
#define OHW_R5KEOP	0x00000004U /* patch for R5000 branch at end-of-page bug */
#define OHW_R5KCVTL	0x00000008U /* R5000 cvt.[ds].l bug: clean == 1 */
#define OHW_R10KLDL	0x00000010U /* need patch for R10000 misaligned load */
#define OHWA0_R4KEOP_CHECKED 0x00000001U /* object checked for R4000 end-of-page bug */
#define OHWA0_R4KEOP_CLEAN 0x00000002U /* object verified clean for R4000 end-of-page bug */
#define OHWO0_FIXADE	0x00000001U /* object requires call to fixade */


/*
 * ODK_IDENT/ODK_GP_GROUP info field masks.
 */

#define OGP_GROUP	0x0000FFFFU /* GP group number */
#define OGP_SELF	0x00010000U /* GP group is self-contained */


/*
 * MIPS ELF register info descriptor.
 */

/* 32 bit RegInfo entry. */
typedef struct {
	Elf32_Word	ri_gprmask;  /* Mask of general register used. */
	Elf32_Word	ri_cprmask[4]; /* Mask of coprocessor register used. */
	Elf32_Addr	ri_gp_value; /* GP register value. */
} Elf32_RegInfo;

/* 64 bit RegInfo entry. */
typedef struct {
	Elf64_Word	ri_gprmask;  /* Mask of general register used. */
	Elf64_Word	ri_pad;	     /* Padding. */
	Elf64_Word	ri_cprmask[4]; /* Mask of coprocessor register used. */
	Elf64_Addr	ri_gp_value; /* GP register value. */
} Elf64_RegInfo;

/*
 * Program Header Table (PHDR) entries.
 */

/* 32 bit PHDR entry. */
typedef struct {
	Elf32_Word	p_type;	     /* Type of segment. */
	Elf32_Off	p_offset;    /* File offset to segment. */
	Elf32_Addr	p_vaddr;     /* Virtual address in memory. */
	Elf32_Addr	p_paddr;     /* Physical address (if relevant). */
	Elf32_Word	p_filesz;    /* Size of segment in file. */
	Elf32_Word	p_memsz;     /* Size of segment in memory. */
	Elf32_Word	p_flags;     /* Segment flags. */
	Elf32_Word	p_align;     /* Alignment constraints. */
} Elf32_Phdr;

/* 64 bit PHDR entry. */
typedef struct {
	Elf64_Word	p_type;	     /* Type of segment. */
	Elf64_Word	p_flags;     /* Segment flags. */
	Elf64_Off	p_offset;    /* File offset to segment. */
	Elf64_Addr	p_vaddr;     /* Virtual address in memory. */
	Elf64_Addr	p_paddr;     /* Physical address (if relevant). */
	Elf64_Xword	p_filesz;    /* Size of segment in file. */
	Elf64_Xword	p_memsz;     /* Size of segment in memory. */
	Elf64_Xword	p_align;     /* Alignment constraints. */
} Elf64_Phdr;


/*
 * Move entries, for describing data in COMMON blocks in a compact
 * manner.
 */

/* 32-bit move entry. */
typedef struct {
	Elf32_Lword	m_value;     /* Initialization value. */
	Elf32_Word 	m_info;	     /* Encoded size and index. */
	Elf32_Word	m_poffset;   /* Offset relative to symbol. */
	Elf32_Half	m_repeat;    /* Repeat count. */
	Elf32_Half	m_stride;    /* Number of units to skip. */
} Elf32_Move;

/* 64-bit move entry. */
typedef struct {
	Elf64_Lword	m_value;     /* Initialization value. */
	Elf64_Xword 	m_info;	     /* Encoded size and index. */
	Elf64_Xword	m_poffset;   /* Offset relative to symbol. */
	Elf64_Half	m_repeat;    /* Repeat count. */
	Elf64_Half	m_stride;    /* Number of units to skip. */
} Elf64_Move;

#define ELF32_M_SYM(I)		((I) >> 8)
#define ELF32_M_SIZE(I)		((unsigned char) (I))
#define ELF32_M_INFO(M, S)	(((M) << 8) + (unsigned char) (S))

#define ELF64_M_SYM(I)		((I) >> 8)
#define ELF64_M_SIZE(I)		((unsigned char) (I))
#define ELF64_M_INFO(M, S)	(((M) << 8) + (unsigned char) (S))

/*
 * Section Header Table (SHDR) entries.
 */

/* 32 bit SHDR */
typedef struct {
	Elf32_Word	sh_name;     /* index of section name */
	Elf32_Word	sh_type;     /* section type */
	Elf32_Word	sh_flags;    /* section flags */
	Elf32_Addr	sh_addr;     /* in-memory address of section */
	Elf32_Off	sh_offset;   /* file offset of section */
	Elf32_Word	sh_size;     /* section size in bytes */
	Elf32_Word	sh_link;     /* section header table link */
	Elf32_Word	sh_info;     /* extra information */
	Elf32_Word	sh_addralign; /* alignment constraint */
	Elf32_Word	sh_entsize;   /* size for fixed-size entries */
} Elf32_Shdr;

/* 64 bit SHDR */
typedef struct {
	Elf64_Word	sh_name;     /* index of section name */
	Elf64_Word	sh_type;     /* section type */
	Elf64_Xword	sh_flags;    /* section flags */
	Elf64_Addr	sh_addr;     /* in-memory address of section */
	Elf64_Off	sh_offset;   /* file offset of section */
	Elf64_Xword	sh_size;     /* section size in bytes */
	Elf64_Word	sh_link;     /* section header table link */
	Elf64_Word	sh_info;     /* extra information */
	Elf64_Xword	sh_addralign; /* alignment constraint */
	Elf64_Xword	sh_entsize;  /* size for fixed-size entries */
} Elf64_Shdr;


/*
 * Symbol table entries.
 */

typedef struct {
	Elf32_Word	st_name;     /* index of symbol's name */
	Elf32_Addr	st_value;    /* value for the symbol */
	Elf32_Word	st_size;     /* size of associated data */
	unsigned char	st_info;     /* type and binding attributes */
	unsigned char	st_other;    /* visibility */
	Elf32_Half	st_shndx;    /* index of related section */
} Elf32_Sym;

typedef struct {
	Elf64_Word	st_name;     /* index of symbol's name */
	unsigned char	st_info;     /* type and binding attributes */
	unsigned char	st_other;    /* visibility */
	Elf64_Half	st_shndx;    /* index of related section */
	Elf64_Addr	st_value;    /* value for the symbol */
	Elf64_Xword	st_size;     /* size of associated data */
} Elf64_Sym;

#define ELF32_ST_BIND(I)	((I) >> 4)
#define ELF32_ST_TYPE(I)	((I) & 0xFU)
#define ELF32_ST_INFO(B,T)	(((B) << 4) + ((T) & 0xF))

#define ELF64_ST_BIND(I)	((I) >> 4)
#define ELF64_ST_TYPE(I)	((I) & 0xFU)
#define ELF64_ST_INFO(B,T)	(((B) << 4) + ((T) & 0xF))

#define ELF32_ST_VISIBILITY(O)	((O) & 0x3)
#define ELF64_ST_VISIBILITY(O)	((O) & 0x3)

/*
 * Syminfo descriptors, containing additional symbol information.
 */

/* 32-bit entry. */
typedef struct {
	Elf32_Half	si_boundto;  /* Entry index with additional flags. */
	Elf32_Half	si_flags;    /* Flags. */
} Elf32_Syminfo;

/* 64-bit entry. */
typedef struct {
	Elf64_Half	si_boundto;  /* Entry index with additional flags. */
	Elf64_Half	si_flags;    /* Flags. */
} Elf64_Syminfo;

/*
 * Relocation descriptors.
 */

typedef struct {
	Elf32_Addr	r_offset;    /* location to apply relocation to */
	Elf32_Word	r_info;	     /* type+section for relocation */
} Elf32_Rel;

typedef struct {
	Elf32_Addr	r_offset;    /* location to apply relocation to */
	Elf32_Word	r_info;      /* type+section for relocation */
	Elf32_Sword	r_addend;    /* constant addend */
} Elf32_Rela;

typedef struct {
	Elf64_Addr	r_offset;    /* location to apply relocation to */
	Elf64_Xword	r_info;      /* type+section for relocation */
} Elf64_Rel;

typedef struct {
	Elf64_Addr	r_offset;    /* location to apply relocation to */
	Elf64_Xword	r_info;      /* type+section for relocation */
	Elf64_Sxword	r_addend;    /* constant addend */
} Elf64_Rela;


#define ELF32_R_SYM(I)		((I) >> 8)
#define ELF32_R_TYPE(I)		((unsigned char) (I))
#define ELF32_R_INFO(S,T)	(((S) << 8) + (unsigned char) (T))

#define ELF64_R_SYM(I)		((I) >> 32)
#define ELF64_R_TYPE(I)		((I) & 0xFFFFFFFFUL)
#define ELF64_R_INFO(S,T)	\
	(((Elf64_Xword) (S) << 32) + ((T) & 0xFFFFFFFFUL))

/*
 * Symbol versioning structures.
 */

/* 32-bit structures. */
typedef struct
{
	Elf32_Word	vda_name;    /* Index to name. */
	Elf32_Word	vda_next;    /* Offset to next entry. */
} Elf32_Verdaux;

typedef struct
{
	Elf32_Word	vna_hash;    /* Hash value of dependency name. */
	Elf32_Half	vna_flags;   /* Flags. */
	Elf32_Half	vna_other;   /* Unused. */
	Elf32_Word	vna_name;    /* Offset to dependency name. */
	Elf32_Word	vna_next;    /* Offset to next vernaux entry. */
} Elf32_Vernaux;

typedef struct
{
	Elf32_Half	vd_version;  /* Version information. */
	Elf32_Half	vd_flags;    /* Flags. */
	Elf32_Half	vd_ndx;	     /* Index into the versym section. */
	Elf32_Half	vd_cnt;	     /* Number of aux entries. */
	Elf32_Word	vd_hash;     /* Hash value of name. */
	Elf32_Word	vd_aux;	     /* Offset to aux entries. */
	Elf32_Word	vd_next;     /* Offset to next version definition. */
} Elf32_Verdef;

typedef struct
{
	Elf32_Half	vn_version;  /* Version number. */
	Elf32_Half	vn_cnt;	     /* Number of aux entries. */
	Elf32_Word	vn_file;     /* Offset of associated file name. */
	Elf32_Word	vn_aux;	     /* Offset of vernaux array. */
	Elf32_Word	vn_next;     /* Offset of next verneed entry. */
} Elf32_Verneed;

typedef Elf32_Half	Elf32_Versym;

/* 64-bit structures. */

typedef struct {
	Elf64_Word	vda_name;    /* Index to name. */
	Elf64_Word	vda_next;    /* Offset to next entry. */
} Elf64_Verdaux;

typedef struct {
	Elf64_Word	vna_hash;    /* Hash value of dependency name. */
	Elf64_Half	vna_flags;   /* Flags. */
	Elf64_Half	vna_other;   /* Unused. */
	Elf64_Word	vna_name;    /* Offset to dependency name. */
	Elf64_Word	vna_next;    /* Offset to next vernaux entry. */
} Elf64_Vernaux;

typedef struct {
	Elf64_Half	vd_version;  /* Version information. */
	Elf64_Half	vd_flags;    /* Flags. */
	Elf64_Half	vd_ndx;	     /* Index into the versym section. */
	Elf64_Half	vd_cnt;	     /* Number of aux entries. */
	Elf64_Word	vd_hash;     /* Hash value of name. */
	Elf64_Word	vd_aux;	     /* Offset to aux entries. */
	Elf64_Word	vd_next;     /* Offset to next version definition. */
} Elf64_Verdef;

typedef struct {
	Elf64_Half	vn_version;  /* Version number. */
	Elf64_Half	vn_cnt;	     /* Number of aux entries. */
	Elf64_Word	vn_file;     /* Offset of associated file name. */
	Elf64_Word	vn_aux;	     /* Offset of vernaux array. */
	Elf64_Word	vn_next;     /* Offset of next verneed entry. */
} Elf64_Verneed;

typedef Elf64_Half	Elf64_Versym;


/*
 * The header for GNU-style hash sections.
 */

typedef struct {
	uint32_t	gh_nbuckets;	/* Number of hash buckets. */
	uint32_t	gh_symndx;	/* First visible symbol in .dynsym. */
	uint32_t	gh_maskwords;	/* #maskwords used in bloom filter. */
	uint32_t	gh_shift2;	/* Bloom filter shift count. */
} Elf_GNU_Hash_Header;

#endif	/* _SYS_ELFDEFINITIONS_H_ */
