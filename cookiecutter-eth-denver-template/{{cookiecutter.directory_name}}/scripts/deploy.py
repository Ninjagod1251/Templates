from ape import project
from ape.cli import get_user_selected_account
from ape_tokens import tokens


def deploy():
    account = get_user_selected_account(
        prompt_message=f"Select an account to deploy the Upstream token"
    )
    weth = tokens["WETH"]
    account.deploy(project.{{cookiecutter.smart_contract_file_name}}, weth.address)


def main():
    deploy()
