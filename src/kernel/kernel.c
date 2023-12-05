/*
 * Copyright (C) 2023 Konstanty Misiak
 *
 * SPDX-License-Identifier: MIT
 */

#include "../drivers/screen.h"

static const char* message2 = "qwery";

void kmain()
{
    clear_screen();
    //print("Welcome to KostuOS");

    //print_at("asd", 1, 1);

    const char* message = "ASDF";
    int i = 0;
	//while(message[i] != 0)
	print_char('A', -1, -1, WHITE_ON_BLACK);
    print_char(message[0], -1, -1, WHITE_ON_BLACK);
    print_char(message2[0], -1, -1, WHITE_ON_BLACK);
}
