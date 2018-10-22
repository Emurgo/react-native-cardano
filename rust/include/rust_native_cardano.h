#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_OUTPUT_SIZE 4096

#define NONCE_SIZE 12

#define SALT_SIZE 32

#define TAG_SIZE 16

#define XPRV_SIZE 96

void dealloc_string(char *ptr);

uintptr_t wallet_from_enhanced_entropy_safe(const unsigned char *entropy_ptr,
                                            uintptr_t entropy_size,
                                            const unsigned char *password_ptr,
                                            uintptr_t password_size,
                                            unsigned char *out,
                                            char **error);

int32_t xwallet_account_safe(const unsigned char *input_ptr,
                             uintptr_t input_sz,
                             unsigned char *output_ptr,
                             char **error);

int32_t xwallet_addresses_safe(const unsigned char *input_ptr,
                               uintptr_t input_sz,
                               unsigned char *output_ptr,
                               char **error);

int32_t xwallet_from_master_key_safe(const unsigned char *input_ptr,
                                     unsigned char *output_ptr,
                                     char **error);
