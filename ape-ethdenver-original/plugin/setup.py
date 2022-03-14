#!/usr/bin/env python
# -*- coding: utf-8 -*-
from setuptools import find_packages, setup  # type: ignore

extras_require = {
    "test": ["pytest>=6.0,<7.0"],
    "lint": [
        "black>=21.10b0,<22.0",
        "mypy>=0.910,<1.0",
        "flake8>=3.9.2,<4.0",
        "isort>=5.9.3,<6.0",
    ],
}
extras_require["dev"] = extras_require["test"] + extras_require["lint"]


setup(
    name="ape-chainstack",
    version="0.1.0a1",
    description="""ape-chainstack: Chainstack Provider plugins for Ethereum-based networks""",
    author="EthDenver participant",
    author_email="jane@example.com",
    url="https://github.com/unparalleled-js/ape-ethdenver",
    include_package_data=True,
    install_requires=[
        "eth-ape>=0.1.0b4",
        "importlib-metadata ; python_version<'3.8'",
    ],
    python_requires=">=3.7,<4",
    extras_require=extras_require,
    py_modules=["ape_chainstack"],
    license="Apache-2.0",
    zip_safe=False,
    keywords="ethereum",
    packages=find_packages(exclude=["tests", "tests.*"]),
    package_data={"ape_chainstack": ["py.typed"]},
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Natural Language :: English",
        "Operating System :: MacOS",
        "Operating System :: POSIX",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
    ],
)
