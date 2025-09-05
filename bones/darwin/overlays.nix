self: super:

{
  harfbuzz = super.harfbuzz.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
}
