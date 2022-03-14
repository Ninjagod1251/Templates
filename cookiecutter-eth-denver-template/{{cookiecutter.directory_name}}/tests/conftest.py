
import pytest
import ape

from ape_tokens import tokens


@pytest.fixture
def owner(accounts):
    return accounts[0]


@pytest.fixture
def some_rando(accounts):
    return accounts[1]


@pytest.fixture
def weth_holder():
    return ape.accounts.load("weth_account")


@pytest.fixture
def token(owner, project):
    weth_address = tokens["WETH"].address  # Upstream token
    return owner.deploy(project.DownstreamERC20, weth_address)
