defmodule Votr.Identity.TotpTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias Votr.Identity.Totp

  test "calculate_code/2" do
    secret1 = Base.decode32!("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    secret2 = "12345678901234567890"

    # https://2fa.glitch.me/
    assert 982402 = Totp.calculate_code(secret1, 7153200792)
    assert 872352 = Totp.calculate_code(secret1, 4767074704)
    assert 356102 = Totp.calculate_code(secret1, 50811593)

    assert 287082 = Totp.calculate_code(secret2, 0x0000001)
    assert 081804 = Totp.calculate_code(secret2, 0x23523EC)
    assert 050471 = Totp.calculate_code(secret2, 0x23523ED)
    assert 005924 = Totp.calculate_code(secret2, 0x273EF07)
    assert 279037 = Totp.calculate_code(secret2, 0x3F940AA)
    assert 353130 = Totp.calculate_code(secret2, 0x27BC86AA)
  end

end
