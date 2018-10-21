#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#define ITER 19162

#define KEY_SIZE 32

#define NONCE_SIZE 12

#define SALT_SIZE 32

#define SALT_START 0

#define TAG_SIZE 16

#define XPRV_SIZE 96

#define XPUB_SIZE 64

#define SEED_SIZE 32

#define SIGNATURE_SIZE 64

void *alloc(uintptr_t size);

void blake2b_256(const unsigned char *msg_ptr, uintptr_t msg_sz, unsigned char *out);

void dealloc(void *ptr, uintptr_t cap);

void dealloc_str(char *ptr);

int32_t decrypt_with_password(const unsigned char *password_ptr,
                              uintptr_t password_sz,
                              const unsigned char *data_ptr,
                              uintptr_t data_sz,
                              unsigned char *output_ptr);

int32_t encrypt_with_password(const unsigned char *password_ptr,
                              uintptr_t password_sz,
                              const unsigned char *salt_ptr,
                              const unsigned char *nonce_ptr,
                              const unsigned char *data_ptr,
                              uintptr_t data_sz,
                              unsigned char *output_ptr);

void paper_scramble(const unsigned char *iv_ptr,
                    const unsigned char *pass_ptr,
                    uintptr_t pass_sz,
                    const unsigned char *input_ptr,
                    uintptr_t input_sz,
                    unsigned char *out);

void paper_unscramble(const unsigned char *pass_ptr,
                      uintptr_t pass_sz,
                      const unsigned char *input_ptr,
                      uintptr_t input_sz,
                      unsigned char *out);

char *pbkdf2_sha256(char *password, char *salt, uint32_t iters, uint32_t output);

int32_t random_address_check(const unsigned char *input_ptr,
                             uintptr_t input_sz,
                             unsigned char *output_ptr);

int32_t random_address_checker_from_mnemonics(const unsigned char *input_ptr,
                                              uintptr_t input_sz,
                                              unsigned char *output_ptr);

int32_t random_address_checker_new(const unsigned char *input_ptr,
                                   uintptr_t input_sz,
                                   unsigned char *output_ptr);

uint32_t wallet_address_get_payload(const unsigned char *addr_ptr,
                                    uintptr_t addr_sz,
                                    unsigned char *out);

void wallet_derive_private(const unsigned char *xprv_ptr, uint32_t index, unsigned char *out);

bool wallet_derive_public(const unsigned char *xpub_ptr, uint32_t index, unsigned char *out);

void wallet_from_daedalus_seed(const unsigned char *seed_ptr, unsigned char *out);

uintptr_t wallet_from_enhanced_entropy(const unsigned char *entropy_ptr,
                                       uintptr_t entropy_size,
                                       const unsigned char *password_ptr,
                                       uintptr_t password_size,
                                       unsigned char *out);

void wallet_from_seed(const unsigned char *seed_ptr, unsigned char *out);

uint32_t wallet_payload_decrypt(const unsigned char *key_ptr,
                                const unsigned char *payload_ptr,
                                uintptr_t payload_sz,
                                unsigned int *out);

uint32_t wallet_payload_encrypt(const unsigned char *key_ptr,
                                const unsigned int *path_array,
                                uintptr_t path_sz,
                                unsigned char *out);

void wallet_payload_initiate(const unsigned char *xpub_ptr, unsigned char *out);

uint32_t wallet_public_to_address(const unsigned char *xpub_ptr,
                                  const unsigned char *payload_ptr,
                                  uintptr_t payload_sz,
                                  unsigned char *out);

void wallet_sign(const unsigned char *xprv_ptr,
                 const unsigned char *msg_ptr,
                 uintptr_t msg_sz,
                 unsigned char *out);

void wallet_to_public(const unsigned char *xprv_ptr, unsigned char *out);

uint32_t wallet_tx_add_txin(const unsigned char *tx_ptr,
                            uintptr_t tx_sz,
                            const unsigned char *txin_ptr,
                            uintptr_t txin_sz,
                            unsigned char *out);

uint32_t wallet_tx_add_txout(const unsigned char *tx_ptr,
                             uintptr_t tx_sz,
                             const unsigned char *txout_ptr,
                             uintptr_t txout_sz,
                             unsigned char *out);

uint32_t wallet_tx_new(unsigned char *out);

void wallet_tx_sign(const unsigned char *cfg_ptr,
                    uintptr_t cfg_size,
                    const unsigned char *xprv_ptr,
                    const unsigned char *tx_ptr,
                    uintptr_t tx_sz,
                    unsigned char *out);

int32_t wallet_tx_verify(const unsigned char *cfg_ptr,
                         uintptr_t cfg_size,
                         const unsigned char *xpub_ptr,
                         const unsigned char *tx_ptr,
                         uintptr_t tx_sz,
                         const unsigned char *sig_ptr);

uint32_t wallet_txin_create(const unsigned char *txid_ptr, uint32_t index, unsigned char *out);

uint32_t wallet_txout_create(const unsigned char *ea_ptr,
                             uintptr_t ea_sz,
                             uint32_t amount,
                             unsigned char *out);

bool wallet_verify(const unsigned char *xpub_ptr,
                   const unsigned char *msg_ptr,
                   uintptr_t msg_sz,
                   const unsigned char *sig_ptr);

int32_t xwallet_account(const unsigned char *input_ptr,
                        uintptr_t input_sz,
                        unsigned char *output_ptr);

int32_t xwallet_addresses(const unsigned char *input_ptr,
                          uintptr_t input_sz,
                          unsigned char *output_ptr);

int32_t xwallet_checkaddress(const unsigned char *input_ptr,
                             uintptr_t input_sz,
                             unsigned char *output_ptr);

int32_t xwallet_create(const unsigned char *input_ptr,
                       uintptr_t input_sz,
                       unsigned char *output_ptr);

int32_t xwallet_create_daedalus_mnemonic(const unsigned char *input_ptr,
                                         uintptr_t input_sz,
                                         unsigned char *output_ptr);

int32_t xwallet_from_master_key(const unsigned char *input_ptr, unsigned char *output_ptr);

int32_t xwallet_move(const unsigned char *input_ptr, uintptr_t input_sz, unsigned char *output_ptr);

int32_t xwallet_spend(const unsigned char *input_ptr,
                      uintptr_t input_sz,
                      unsigned char *output_ptr);
