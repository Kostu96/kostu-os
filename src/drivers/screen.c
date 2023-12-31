/*
 * Copyright (C) 2023 Konstanty Misiak
 *
 * SPDX-License-Identifier: MIT
 */

#include "screen.h"
#include "../kernel/low_level.h"
#include "../kernel/utils.h"

void print_at(char *message, int col, int row);
void print_char(char character, int col, int row, char attribute_byte);
int get_screen_offset(int col, int row);
int get_cursor();
void set_cursor(int offset);
int handle_scrolling(int offset);

void print(char *message)
{
	print_at(message , -1, -1);
}

void print_at(char *message, int col, int row)
{ 
	if (col >= 0 && row >= 0)
		set_cursor(get_screen_offset(col, row));
	
	int i = 0;
	while(message[i] != 0)
		print_char(message[i++], -1, -1, WHITE_ON_BLACK);
}

void print_char(char character, int col, int row, char attribute_byte)
{
    unsigned char *video_memory = (unsigned char *)VIDEO_ADDRESS;
    
    if (!attribute_byte) attribute_byte = WHITE_ON_BLACK;
    
    int offset = (col >= 0 && row >= 0) ? get_screen_offset(col, row) : get_cursor();
    
    if (character == '\n')
    {
        int rows = offset / (2 * MAX_COLS);
        offset = get_screen_offset(MAX_COLS - 1, rows);
    } else {
        video_memory[offset] = character;
        video_memory[offset + 1] = attribute_byte;
    }

    offset += 2;
    offset = handle_scrolling(offset);
    set_cursor(offset);
}

int get_screen_offset(int col, int row)
{
	return (row * MAX_COLS + col) * 2;
}

int get_cursor()
{
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	
	return offset * 2;
}

void set_cursor(int offset)
{
	offset /= 2; 
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)offset);
}

int handle_scrolling(int offset)
{
	if (offset < MAX_ROWS * MAX_COLS * 2)
		return offset;
	
	for (int i = 1; i < MAX_ROWS; ++i)
		memory_copy((char*)(get_screen_offset(0, i) + VIDEO_ADDRESS),
		            (char*)(get_screen_offset(0, i - 1) + VIDEO_ADDRESS),
					MAX_COLS * 2);
	
	char* last_line = (char*)(get_screen_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
	for (int i = 0; i < MAX_COLS * 2; ++i)
	{
		last_line[i] = 0;
	}
	
	offset -= 2 * MAX_COLS;
	return offset;
}

void clear_screen()
{
	int row, col;
	for (row = 0; row < MAX_ROWS; ++row)
		for (col = 0; col < MAX_COLS; ++col)
			print_char(' ', col, row, WHITE_ON_BLACK);
	
	set_cursor(get_screen_offset(0, 0));
}
