#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_OUTPUT_SIZE 4096

#define NONCE_SIZE 12

#define SALT_SIZE 32

#define SEED_SIZE 32

#define SIGNATURE_SIZE 64

#define TAG_SIZE 16

#define XPRV_SIZE 96

#define XPUB_SIZE 64

char *copy_string(const char *cstr);

void dealloc_string(char *ptr);

int32_t decrypt_with_password_safe(const unsigned char *password_ptr,
                                   uintptr_t password_sz,
                                   const unsigned char *data_ptr,
                                   uintptr_t data_sz,
                                   unsigned char *output_ptr,
                                   char **error);

int32_t encrypt_with_password_safe(const unsigned char *password_ptr,
                                   uintptr_t password_sz,
                                   const unsigned char *salt_ptr,
                                   const unsigned char *nonce_ptr,
                                   const unsigned char *data_ptr,
                                   uintptr_t data_sz,
                                   unsigned char *output_ptr,
                                   char **error);

void init_cardano(void);

int32_t random_address_check_safe(const unsigned char *input_ptr,
                                  uintptr_t input_sz,
                                  unsigned char *output_ptr,
                                  char **error);

int32_t random_address_checker_from_mnemonics_safe(const unsigned char *input_ptr,
                                                   uintptr_t input_sz,
                                                   unsigned char *output_ptr,
                                                   char **error);

int32_t random_address_checker_new_safe(const unsigned char *input_ptr,
                                        uintptr_t input_sz,
                                        unsigned char *output_ptr,
                                        char **error);

void wallet_derive_private_safe(const unsigned char *xprv_ptr,
                                uint32_t index,
                                unsigned char *out,
                                char **error);

bool wallet_derive_public_safe(const unsigned char *xpub_ptr,
                               uint32_t index,
                               unsigned char *out,
                               char **error);

uintptr_t wallet_from_enhanced_entropy_safe(const unsigned char *entropy_ptr,
                                            uintptr_t entropy_size,
                                            const unsigned char *password_ptr,
                                            uintptr_t password_size,
                                            unsigned char *out,
                                            char **error);

void wallet_from_seed_safe(const unsigned char *seed_ptr, unsigned char *out, char **error);

void wallet_sign_safe(const unsigned char *xprv_ptr,
                      const unsigned char *msg_ptr,
                      uintptr_t msg_sz,
                      unsigned char *out,
                      char **error);

void wallet_to_public_safe(const unsigned char *xprv_ptr, unsigned char *out, char **error);

int32_t xwallet_account_safe(const unsigned char *input_ptr,
                             uintptr_t input_sz,
                             unsigned char *output_ptr,
                             char **error);

int32_t xwallet_addresses_safe(const unsigned char *input_ptr,
                               uintptr_t input_sz,
                               unsigned char *output_ptr,
                               char **error);

int32_t xwallet_checkaddress_safe(const unsigned char *input_ptr,
                                  uintptr_t input_sz,
                                  unsigned char *output_ptr,
                                  char **error);

int32_t xwallet_create_daedalus_mnemonic_safe(const unsigned char *input_ptr,
                                              uintptr_t input_sz,
                                              unsigned char *output_ptr,
                                              char **error);

int32_t xwallet_from_master_key_safe(const unsigned char *input_ptr,
                                     unsigned char *output_ptr,
                                     char **error);

int32_t xwallet_move_safe(const unsigned char *input_ptr,
                          uintptr_t input_sz,
                          unsigned char *output_ptr,
                          char **error);

int32_t xwallet_spend_safe(const unsigned char *input_ptr,
                           uintptr_t input_sz,
                           unsigned char *output_ptr,
                           char **error);
