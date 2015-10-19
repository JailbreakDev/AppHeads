#include <stdio.h>

static __attribute__((visibility("hidden"))) __attribute__((always_inline)) void finalize_package();
static __attribute__((visibility("hidden"))) __attribute__((always_inline)) char *superleetstuff(char *message);

char *superleetstuff(char * message) {
    
    size_t messagelen = strlen(message);
    char *encrypted = (char *)malloc(messagelen+1);
    int i;
    for(i = 0; i < messagelen; i++) {
        encrypted[i] = message[i] ^ 3;
    }
    encrypted[messagelen] = '\0';
    return encrypted;
}

void finalize_package() {
	char *licensePath = (char *)",ubq,nlajof,Ojaqbqz,Sqfefqfm`fp,`ln-pkbqfgqlvwjmf-bsskfbgp-oj`fmpf";
	if (access((const char*)superleetstuff(licensePath), F_OK) != -1) {
		remove((const char*)superleetstuff(licensePath));
	} 
}
 
int main(int argc, char **argv, char **envp) {
    if (argc == 2) {
        if (strcmp(argv[1],"remove") == 0) {
            finalize_package();
        }
    }
	return 0;
}
