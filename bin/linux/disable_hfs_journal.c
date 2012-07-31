#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <byteswap.h>



int main(int argc, char *argv[])
{
	int fd = open(argv[1], O_RDWR);
	if(fd < 0) {
		perror("open");
		return -1;
	}
	
	unsigned char *buffer = (unsigned char *)mmap(NULL, 2048, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if(buffer == (unsigned char*)0xffffffff) {
		perror("mmap");
		return -1;
	}
	
	if((buffer[1024] != 'H') && (buffer[1025] != '+')) {
		fprintf(stderr, "%s: HFS+ signature not found -- aborting.\n", argv[0]);
		return -1;
	}
	
	unsigned long attributes = *(unsigned long *)(&buffer[1028]);
	attributes = bswap_32(attributes);
	printf("attributes = 0x%8.8lx\n", attributes);
	
	if(!(attributes & 0x00002000)) {
		printf("kHFSVolumeJournaledBit not currently set in the volume attributes field.\n");
	}
	
	attributes &= 0xffffdfff;
	attributes = bswap_32(attributes);
	*(unsigned long *)(&buffer[1028]) = attributes;
	
	buffer[1032] = '1';
	buffer[1033] = '0';
	buffer[1034] = '.';
	buffer[1035] = '0';
	
	buffer[1036] = 0;
	buffer[1037] = 0;
	buffer[1038] = 0;
	buffer[1039] = 0;
	
	printf("journal has been disabled.\n");
	return 0;
}
