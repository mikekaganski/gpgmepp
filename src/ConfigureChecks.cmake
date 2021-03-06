# gpgme configure checks
include(CheckFunctionExists)
include(CheckTypeSize)

if ( GPGME_FOUND )

set(CMAKE_REQUIRED_INCLUDES_SAVE ${CMAKE_REQUIRED_INCLUDES})
set(CMAKE_REQUIRED_LIBRARIES_SAVE ${CMAKE_REQUIRED_LIBRARIES})
set(CMAKE_REQUIRED_INCLUDES ${GPGME_INCLUDES})
set(CMAKE_REQUIRED_DEFINITIONS ${KDE4_DEFINITIONS})
set(CMAKE_REQUIRED_LIBRARIES)
foreach( _FLAVOUR VANILLA PTHREAD QT PTH GLIB )
  if ( NOT CMAKE_REQUIRED_LIBRARIES )
    if ( GPGME_${_FLAVOUR}_FOUND )
      set(CMAKE_REQUIRED_LIBRARIES ${GPGME_VANILLA_LIBRARIES})
    endif()
  endif()
endforeach( _FLAVOUR )

# check if gpgme has gpgme_data_{get,set}_file_name (new in 1.1.0)
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_data_t data = 0;
    const char * filename = 0;
    const gpgme_error_t err = gpgme_data_set_file_name( data, filename );
    char * filename2 = gpgme_data_get_file_name( data );
    (void)filename2; (void)err;
    return 0;
  }
" HAVE_GPGME_DATA_SET_FILE_NAME
)

# check if gpgme has GPGME_INCLUDE_CERTS_DEFAULT
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    int i = GPGME_INCLUDE_CERTS_DEFAULT;
    return 0;
  }
" HAVE_GPGME_INCLUDE_CERTS_DEFAULT
)

# check if gpgme has GPGME_KEYLIST_MODE_SIG_NOTATIONS
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_keylist_mode_t mode = GPGME_KEYLIST_MODE_SIG_NOTATIONS;
    return 0;
  }
" HAVE_GPGME_KEYLIST_MODE_SIG_NOTATIONS
)

# check if gpgme_key_sig_t has notations
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_key_sig_t key_sig = 0;
    gpgme_sig_notation_t notation = key_sig->notations;
    return 0;
  }
" HAVE_GPGME_KEY_SIG_NOTATIONS
)

# check if gpgme has gpgme_key_t->is_qualified
check_cxx_source_compiles ("
  #include <gpgme.h>
  void test(gpgme_key_t& key) {
    unsigned int iq;
    iq = key->is_qualified;
  }
  int main() { return 0; }
" HAVE_GPGME_KEY_T_IS_QUALIFIED 
)

# check if gpgme has gpgme_sig_notation_t->critical
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_sig_notation_t sig_notation = 0;
    unsigned int cr1 = sig_notation->critical;
    unsigned int cr2 = GPGME_SIG_NOTATION_CRITICAL;
    return 0;
  }
" HAVE_GPGME_SIG_NOTATION_CRITICAL
)

# check if gpgme has gpgme_sig_notation_t->flags
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_sig_notation_t sig_notation = 0;
    gpgme_sig_notation_flags_t f = sig_notation->flags;
    return 0;
  }
" HAVE_GPGME_SIG_NOTATION_FLAGS_T
)

# check if gpgme has gpgme_sig_notation_t->human_readable
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_sig_notation_t sig_notation = 0;
    unsigned int cr1 = sig_notation->human_readable;
    unsigned int cr2 = GPGME_SIG_NOTATION_HUMAN_READABLE;
    return 0;
  }
" HAVE_GPGME_SIG_NOTATION_HUMAN_READABLE
)

# check if gpgme has gpgme_subkey_t->is_qualified
check_cxx_source_compiles ("
  #include <gpgme.h>
  void test(gpgme_subkey_t& subkey) {
    unsigned int iq;
    iq = subkey->is_qualified;
  }
  int main() { return 0; }
" HAVE_GPGME_SUBKEY_T_IS_QUALIFIED 
)

# check if gpgme has gpgme_engine_info_t->home_dir
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_engine_info_t ei = 0;
    const char * hd = ei->home_dir;
    return 0;
  }
" HAVE_GPGME_ENGINE_INFO_T_HOME_DIR
)

#check if gpgme has gpgme_ctx_{get,set}_engine_info()
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_ctx_t ctx = 0;
    const gpgme_engine_info_t ei = gpgme_ctx_get_engine_info( ctx );
    const char * filename = 0;
    const char * home_dir = 0;
    const gpgme_error_t e
      = gpgme_ctx_set_engine_info( ctx, GPGME_PROTOCOL_OpenPGP, filename, home_dir );
    return 0;
  }
" HAVE_GPGME_CTX_GETSET_ENGINE_INFO
)

# missing, but not needed yet (only for edit interaction)
#+    GPGME_STATUS_SIG_SUBPACKET,
#+    GPGME_STATUS_NEED_PASSPHRASE_PIN,
#+    GPGME_STATUS_SC_OP_FAILURE,
#+    GPGME_STATUS_SC_OP_SUCCESS,
#+    GPGME_STATUS_CARDCTRL,
#+    GPGME_STATUS_BACKUP_KEY_CREATED,
#+    GPGME_STATUS_PKA_TRUST_BAD,
#+    GPGME_STATUS_PKA_TRUST_GOOD,
#+
#+    GPGME_STATUS_PLAINTEXT

# check if gpgme has gpgme_sig_notation_{clear,add,get}
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_ctx_t ctx = 0;
    const gpgme_sig_notation_t nota = gpgme_sig_notation_get( ctx );
    const char * const name = 0;
    const char * const value = 0;
    const gpgme_sig_notation_flags_t flags = 0;
    const gpgme_error_t err = gpgme_sig_notation_add( ctx, name, value, flags );
    gpgme_sig_notation_clear( ctx );
    return 0;
  }
" HAVE_GPGME_SIG_NOTATION_CLEARADDGET
)

# check if gpgme has gpgme_decrypt_result_t->file_name
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_decrypt_result_t res = 0;
    const char * const fn = res->file_name;
    (void)fn;
  }
" HAVE_GPGME_DECRYPT_RESULT_T_FILE_NAME
)

# check if gpgme has gpgme_recipient_t and gpgme_decrypt_result_t->recipients
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_decrypt_result_t res = 0;
    gpgme_recipient_t r = res->recipients;
    const char * kid = r->keyid;
    r = r->next;
    const gpgme_pubkey_algo_t algo = r->pubkey_algo;
    const gpgme_error_t err = r->status;
    return 0;
  }
" HAVE_GPGME_DECRYPT_RESULT_T_RECIPIENTS
)

# check if gpgme has gpgme_verify_result_t->file_name
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_verify_result_t res = 0;
    const char * fn = res->file_name;
    (void)fn;
    return 0;
  }
" HAVE_GPGME_VERIFY_RESULT_T_FILE_NAME
)

# check if gpgme has gpgme_signature_t->pka_{trust,address}
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_signature_t sig = 0;
    unsigned int pkat = sig->pka_trust;
    const char * pkaa = sig->pka_address;
    return 0;
  }
" HAVE_GPGME_SIGNATURE_T_PKA_FIELDS
)

# check if gpgme has gpgme_signature_t->{hash,pubkey}_algo
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_signature_t sig = 0;
    gpgme_pubkey_algo_t pk = sig->pubkey_algo;
    gpgme_hash_algo_t h = sig->hash_algo;
    return 0;
  }
" HAVE_GPGME_SIGNATURE_T_ALGORITHM_FIELDS
)

# check if gpgme has gpgme_signature_t->chain_model
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_signature_t sig = 0;
    unsigned int cm = sig->chain_model;
    return 0;
  }
" HAVE_GPGME_SIGNATURE_T_CHAIN_MODEL
)

# check if gpgme has gpgme_get_fdptr
check_function_exists( "gpgme_get_fdptr" HAVE_GPGME_GET_FDPTR )

# check if gpgme has gpgme_op_getauditlog
check_function_exists ("gpgme_op_getauditlog" HAVE_GPGME_OP_GETAUDITLOG )

# check if gpgme has GPGME_PROTOCOL_GPGCONF
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    const gpgme_protocol_t proto = GPGME_PROTOCOL_GPGCONF;
    gpgme_ctx_t ctx = 0;
    gpgme_conf_comp_t comp = 0;
    gpgme_error_t e = gpgme_op_conf_load( ctx, &comp );
    e = gpgme_op_conf_save( ctx, comp );
    gpgme_conf_arg_t arg = 0;
    int i = 0;
    void * value = &i;
    e = gpgme_conf_arg_new( &arg, GPGME_CONF_INT32, value );
    gpgme_conf_opt_t opt = comp->options;
    e = gpgme_conf_opt_change( opt, 0, arg );
    gpgme_conf_release( comp );
    return 0;
  }
" HAVE_GPGME_PROTOCOL_GPGCONF
)

# check if gpgme has gpgme_cancel_async
check_function_exists ("gpgme_cancel_async" HAVE_GPGME_CANCEL_ASYNC )

# check if gpg-error has GPG_ERR_NO_PASSPHRASE
check_cxx_source_compiles ("
  #include <gpg-error.h>
  int main() {
    gpg_error_t err = GPG_ERR_NO_PASSPHRASE;
    return 0;
  }
" HAVE_GPG_ERR_NO_PASSPHRASE )

# check if gpg-error has GPG_ERR_ALREADY_SIGNED
check_cxx_source_compiles ("
  #include <gpg-error.h>
  int main() {
    gpg_error_t err = GPG_ERR_ALREADY_SIGNED;
    return 0;
  }
" HAVE_GPG_ERR_ALREADY_SIGNED )

# check if gpgme has GPGME_ENCRYPT_NO_ENCRYPT_TO
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_encrypt_flags_t f = GPGME_ENCRYPT_NO_ENCRYPT_TO;
    return 0;
  }
" HAVE_GPGME_ENCRYPT_NO_ENCRYPT_TO )

# check if gpgme has gpgme_subkey_t->is_cardkey and ->card_number
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_subkey_t sk = 0;
    const char * card_number = sk->card_number;
    const unsigned int is_cardkey = sk->is_cardkey;
    return 0;
  }
" HAVE_GPGME_SUBKEY_T_IS_CARDKEY )

# check if gpgme has assuan protocol support
check_cxx_source_compiles ("
  #include <gpgme.h>

  static gpgme_error_t data_cb(void *, const void *, size_t) { return 0; }
  static gpgme_error_t inquire_cb(void *, const char *, const char *, gpgme_data_t *) { return 0; }
  static gpgme_error_t status_cb(void *, const char *, const char *) { return 0; }

  int main() {
     const gpgme_protocol_t proto = GPGME_PROTOCOL_ASSUAN;
     gpgme_ctx_t ctx = 0;
     gpgme_assuan_data_cb_t d = data_cb;
     gpgme_assuan_inquire_cb_t i = inquire_cb;
     gpgme_assuan_status_cb_t s = status_cb;
     gpgme_assuan_result_t r = gpgme_op_assuan_result( ctx );
     void * opaque = 0;
     gpgme_error_t err = gpgme_op_assuan_transact_start( ctx, \"FOO\", d, opaque, i, opaque, s, opaque );
     err = gpgme_op_assuan_transact( ctx, \"FOO\", d, opaque, i, opaque, s, opaque );
     return 0;
  }
" HAVE_GPGME_ASSUAN_ENGINE )

check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_keylist_mode_t mode = GPGME_KEYLIST_MODE_EPHEMERAL;
    return 0;
  }
" HAVE_GPGME_KEYLIST_MODE_EPHEMERAL )

# check if gpgme has import-from-keyserver support
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     gpgme_ctx_t ctx = 0;
     gpgme_key_t keys[2] = { 0, 0 };
     const gpgme_error_t err = gpgme_op_import_keys( ctx, keys );
     return err ? 1 : 0 ;
  }
" HAVE_GPGME_OP_IMPORT_KEYS )

# check for G13 VFS support
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
    gpgme_ctx_t ctx = 0;
    gpgme_key_t users[2] = { 0, 0 };
    gpgme_error_t err, op_err;
    err = gpgme_set_protocol( ctx, GPGME_PROTOCOL_G13 );
    gpgme_op_vfs_create( ctx, users, \"file\", 0, &op_err );
    err = gpgme_op_vfs_mount( ctx, \"file\", \"mountdir\", 0, &op_err );
    gpgme_vfs_mount_result_t res = gpgme_op_vfs_mount_result( ctx );
    return 0;
  }
" HAVE_GPGME_G13_VFS )

# check if gpgme has change-passphrase support
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     gpgme_ctx_t ctx = 0;
     gpgme_key_t key = 0;
     unsigned int flags = 0;
     const gpgme_error_t err = gpgme_op_passwd( ctx, key, flags );
     return err ? 1 : 0 ;
  }
" HAVE_GPGME_OP_PASSWD )

# check if gpgme has gpgme_io_{read,write} (new in 1.2.0)
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     int fd;
     void * cv;
     void * v;
     size_t sz;
     ssize_t r = gpgme_io_read( fd, v, sz );
     r = gpgme_io_write( fd, cv, sz );
     return 0;
  }
" HAVE_GPGME_IO_READWRITE )

# check if gpg-error has gpg_err_set_errno (v1.8)
check_cxx_source_compiles ("
   #include <gpg-error.h>
   int main() {
     int i;
     gpg_err_set_errno( i );
     return 0;
   }
" HAVE_GPG_ERR_SET_ERRNO )

# check if gpgme has gpg-error wrappers
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     const gpgme_error_t err = gpgme_error_from_syserror();
     int i;
     gpgme_err_set_errno( i );
     return 0;
  }
" HAVE_GPGME_GPG_ERROR_WRAPPERS )

# check if gpgme_conf_arg_new takes its 'value' by const void*
check_cxx_source_compiles ("
  #include <gpgme.h>

  int main() {
     gpgme_conf_arg_t arg = 0;
     const void * value = 0;
     gpgme_error_t e = gpgme_conf_arg_new( &arg, GPGME_CONF_STRING, value );
     return 0;
  }
" HAVE_GPGME_CONF_ARG_NEW_WITH_CONST_VALUE )

# check if gpgme has offline mode support (new in 1.6.0)
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     gpgme_set_offline( NULL, 1 );
     return 0;
  }
" HAVE_GPGME_CTX_OFFLINE )

# check if gpgme has identify support (new in 1.4.3)
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     gpgme_data_t data;
     gpgme_data_identify( data, 0 );
     return 0;
  }
" HAVE_GPGME_DATA_IDENTIFY )

# check if gpgme has decent identify support (new in 1.7.0)
# decent means that it supports binary data and has more fine
# grained distinctions
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     gpgme_data_t data;
     gpgme_data_type_t ret = gpgme_data_identify( data, 0 );
     if (ret == GPGME_DATA_TYPE_PGP_SIGNATURE)
       return 0;
     return 0;
  }
" HAVE_GPGME_DATA_IDENTIFY_GOOD )

# check if gpgme knows the encrypt flag SYMMETRIC (new in 1.7.0)
check_cxx_source_compiles ("
  #include <gpgme.h>
  int main() {
     gpgme_encrypt_flags_t f = GPGME_ENCRYPT_SYMMETRIC;
     return 0;
  }
" HAVE_GPGME_ENCRYPT_SYMMETRIC )

# check if gpgme has pubkey_algo name mode support (new in 1.6.1)
check_function_exists ("gpgme_pubkey_algo_string" HAVE_GPGME_PUBKEY_ALGO_STRING )
# check if gpgme has support for data flags
check_function_exists ("gpgme_data_set_flag" HAVE_GPGME_DATA_SET_FLAG)

set(CMAKE_EXTRA_INCLUDE_FILES gpgme.h)
# defined in gpgme versions >= 1.4.2
check_type_size(gpgme_ssize_t GPGME_SSIZE_T)
check_type_size(gpgme_off_t GPGME_OFF_T)
set(CMAKE_EXTRA_INCLUDE_FILES)

set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES_SAVE})
set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES_SAVE})
set(CMAKE_REQUIRED_INCLUDES_SAVE)
set(CMAKE_REQUIRED_LIBRARIES_SAVE)

endif()
