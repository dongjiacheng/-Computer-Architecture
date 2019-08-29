/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here

unsigned odd, even;

	odd = input & 0b01010101010101010101010101010101;
	even = input & 0b10101010101010101010101010101010;
	even = even >> 1;
	input = odd + even;

	odd = input & 0b00110011001100110011001100110011;
	even = input & 0b11001100110011001100110011001100;
	even = even >> 2;
	input = odd + even;

	odd = input & 0b00001111000011110000111100001111;
	even = input & 0b11110000111100001111000011110000;
	even = even >> 4;
	input = odd + even;

	odd = input & 0b00000000111111110000000011111111;
	even = input & 0b11111111000000001111111100000000;
	even = even >> 8;
	input = odd + even;

	odd = input & 0b00000000000000001111111111111111;
	even = input & 0b11111111111111110000000000000000;
	even = even >> 16;
	input = odd + even;	

	return input;
}
