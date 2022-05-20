import ape


#Standard test comes from the interpretation of EIP-20 
ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"

# Test inital state of the contract
def test_initial_state(token, owner):
    # Check the token meta matches the deployment 
    assert token.name() == "Token"
    assert token.symbol() == "TKN"
    assert token.decimals() == 18

    # Check of intial state of authorization
    assert token.owner() == owner

    # Check intial balance of tokens
    assert token.totalSupply() == 1000
    assert token.balanceOf(owner) == 1000 

#Test 3
# Transfer value of amount to an address
# Must fire the transfer event
# Should throw an error of balance of sender does not have enough
def test_transfer(token, owner, accounts) -> bool:
    """
    token call all the methods on the token fixture. because ape is awesome
    ape python interface to python smart contract.

    for example you wan to test transfer
    
    """
    receiver = accounts[1]

    owner_balance = token.balanceOf(owner)
    assert owner_balance == 1000

    receiver_balance = token.balanceOf(receiver) 
    assert receiver_balance == 0


    tx = token.transfer(receiver, 100, sender=owner)
    # Callers MUST handle false from returns (bool success). 
    # Callers MUST NOT assume that false is never returned!
    #assert tx.return_value == True

    logs = list(tx.decode_logs(token.Transfer))
    assert len(logs) == 1
    assert logs[0].sender == owner
    assert logs[0].receiver == receiver
    assert logs[0].amount == 100
#https://docs.apeworx.io/ape/stable/methoddocs/api.html?highlight=decode#ape.api.networks.EcosystemAPI.decode_logs


    receiver_balance = token.balanceOf(receiver) 
    assert receiver_balance == 100

    owner_balance = token.balanceOf(owner)
    assert owner_balance == 900


    #expected insufficient funds failure
    with ape.reverts():
        token.transfer(owner, 200, sender=receiver)
    
#Note Transfers of 0 values MUST be treated as normal transfers 
# and fire the Transfer event.
    tx = token.transfer(owner, 0, sender=owner)
    #assert tx.return_value == True


#This standard provides basic functionality:
# to transfer tokens, 
# as well as allow tokens to be approved 
# so they can be spent by another on-chain third party.
def test_transfer_from(token, owner, accounts):

    receiver, spender = accounts[1:3]

    owner_balance = token.balanceOf(owner)
    assert owner_balance == 1000

    receiver_balance = token.balanceOf(receiver) 
    assert receiver_balance == 0

    # Spender with no allowance cannot send tokens on someone behalf
    with ape.reverts():
        token.transferFrom(owner, receiver, 300, sender=spender)

        
    #get approval for allowance from owner
    tx = token.approve(spender, 300, sender=owner)
    #assert tx.return_value == True

    logs = list(tx.decode_logs(token.Approval))
    assert len(logs) == 1
    assert logs[0].owner == owner
    assert logs[0].spender == spender
    assert logs[0].amount == 300
    
    assert token.allowance(owner,spender) == 300

    # with auth use the allowance to send to receiver via spender(operator)
    tx = token.transferFrom(owner, receiver, 200, sender=spender)    
    #assert tx.return_value == True

    logs = list(tx.decode_logs(token.Transfer))
    assert len(logs) == 1
    assert logs[0].sender == owner
    assert logs[0].receiver == receiver
    assert logs[0].amount == 200
    
    assert token.allowance(owner,spender) == 100

    # cannot exceed authorized allowance
    with ape.reverts():
        token.transferFrom(owner, receiver, 200, sender=spender)
    

    # transferFrom 100
    token.transferFrom(owner, receiver, 100, sender=spender) 
    assert token.balanceOf(spender) == 0
    assert token.balanceOf(receiver) == 300
    assert token.balanceOf(owner) == 700






#Test 4
# Transfer value of amount to an address
# Must fire the transfer event

#Test 4-5 can be to check the validity of Transfer event



#Test 6:
# Test that the transferFrom contract sends a value to an address
#The function SHOULD throw unless the _from account has deliberately authorized 
# the sender of the message via some mechanism.
#Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.


#Test 7
# Check the auth of an operator
# set auth balance to 0 and check to make sure no attacks vectors
#  THOUGH The contract itself shouldn’t enforce it, 
# to allow backwards compatibility with contracts deployed before

def test_approve(token, owner):
    pass
    #UC 1no one can send a token on you behalf
    #UC 2 any approved op cannot send more than auth amount
    # check logs
    # check the return value
    # check how much is allowed to send
# allowance:
# Returns the amount which _spender is still allowed to withdraw from _owner.

#Test 9
# Transfer
#MUST trigger when tokens are transferred, including zero value transfers.
# A token contract which creates new tokens SHOULD trigger a Transfer event 
# with the _from address set to 0x0 when tokens are created.
# should be done in every test