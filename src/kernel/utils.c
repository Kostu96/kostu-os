/*
 * Copyright (C) 2023 Konstanty Misiak
 *
 * SPDX-License-Identifier: MIT
 */

#include "utils.h"

void memory_copy(char *source, char *dest, int no_bytes)
{
	for (int i = 0; i < no_bytes; i++)
		*(dest + i) = *(source + i);
}
