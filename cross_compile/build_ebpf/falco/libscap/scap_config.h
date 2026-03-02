// SPDX-License-Identifier: Apache-2.0
/*
Copyright (C) 2023 The Falco Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

#pragma once

/* #undef HAS_ENGINE_TEST_INPUT */
#define HAS_ENGINE_NODRIVER
#define HAS_ENGINE_SAVEFILE
#define HAS_ENGINE_SOURCE_PLUGIN
#define HAS_ENGINE_BPF
#define HAS_ENGINE_KMOD
#define HAS_ENGINE_MODERN_BPF
/* #undef HAS_ENGINE_GVISOR */
