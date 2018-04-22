defmodule Votr.Identity.TotpTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias Votr.Identity.Totp

  test "calculate_code/2" do
    secret = Base.decode32!("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    assert "12345678901234567890" = secret

    secret32 = Base.decode16!("3132333435363738393031323334353637383930313233343536373839303132")
    secret64 = Base.decode16!(
      "31323334353637383930313233343536373839303132333435363738393031323334353637383930313233343536373839303132333435363738393031323334"
    )



    # https://2fa.glitch.me/
    assert 982402 = Totp.calculate_code(7153200792, secret)
    assert 872352 = Totp.calculate_code(4767074704, secret)
    assert 356102 = Totp.calculate_code(50811593, secret)

    assert 287_082 = Totp.calculate_code(0x0000001, secret)
    assert 46_119_246 = Totp.calculate_code(0x0000001, secret32, :sha256, 8)
    assert 90_693_936 = Totp.calculate_code(0x0000001, secret64, :sha512, 8)

    assert 081_804 = Totp.calculate_code(0x23523EC, secret)
    assert 68_084_774 = Totp.calculate_code(0x23523EC, secret32, :sha256, 8)
    assert 25_091_201 = Totp.calculate_code(0x23523EC, secret64, :sha512, 8)

    assert 050471 = Totp.calculate_code(0x23523ED, secret)
    assert 005924 = Totp.calculate_code(0x273EF07, secret)
    assert 279037 = Totp.calculate_code(0x3F940AA, secret)
    assert 353130 = Totp.calculate_code(0x27BC86AA, secret)
  end

end
