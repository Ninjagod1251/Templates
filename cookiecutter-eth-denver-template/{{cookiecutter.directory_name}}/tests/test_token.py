import ape


def test_upstream_holders_may_have_downstream_tokens(owner, weth_holder, token):
    token.mint(weth_holder, 10, sender=owner)
    balance = token.balanceOf(weth_holder)
    assert balance == 10


def test_non_upstream_holders_may_not_have_downstream_tokens(owner, some_rando, token):
    with ape.reverts():
        token.mint(some_rando, 10, sender=owner)
