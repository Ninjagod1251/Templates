
def test_token(owner, receiver, token):
    #transaction guide https://docs.apeworx.io/ape/stable/userguides/transactions.html
    # expect to uses gas
    token.mint(receiver, 5 ,sender=owner)
    # contract calls are free so you do not need sender=owner

    acutal = token.balanceOf(receiver)
    expect = 5
    assert acutal == expect