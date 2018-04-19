defmodule Votr.AES do
  @config Application.get_env(:votr, Votr.AES)
  # all historical keys are needed for decrypting
  @keys @config[:keys]
  # one key is currently what everything will be encrypted with
  @key_id @config[:default_key_id]

  def encrypt(plaintext, aad \\ "", key_id \\ @key_id) do
    # 128-bit random tag
    tag_len = 16
    # all data encrypted with the current valid key
    key = @keys[key_id]
    # 96-bit random IVs for each encryption
    iv = :crypto.strong_rand_bytes(12)

    {ciphertext, tag} = :crypto.block_encrypt(:aes_gcm, key, iv, {aad, plaintext, tag_len})
    # concat everything together
    key_id <> iv <> tag <> ciphertext
  end

  def decrypt(ciphertext, aad \\ "") do
    <<key_id :: binary - 1, iv :: binary - 12, tag :: binary - 16, ciphertext :: binary>> = ciphertext
    key = @keys[key_id]
    :crypto.block_decrypt(:aes_gcm, key, iv, {aad, ciphertext, tag})
  end
end
