{
  pkgs,
  lib,
  fetchPypi,
  ...
}: pkgs.python3Packages.buildPythonApplication rec {
  pname = "kshift";
  version = "1.2.3";
  pyproject = true;
  src = fetchPypi {
      inherit pname version;
      sha256 = "q+i5i80h8lrJK+3RyxI3pqonb/INyxYOWvZ++njI5EM=";
  };
  propagatedBuildInputs = with pkgs.python3Packages; [ 
    hatchling 
    click
    colorama
    pydantic
    pytest
    pytest-mock
    pyyaml
    requests
  ];

  meta = with lib; {
    description = "idk";
  };
}
