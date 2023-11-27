/*
 * Copyright (C) 2023 Konstanty Misiak
 *
 * SPDX-License-Identifier: MIT
 */

void kmain()
{
    char* video_memory = (char*)0xB8000;
    video_memory[0] = 'X';
}
