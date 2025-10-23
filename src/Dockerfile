FROM fossa/haskell-static-alpine:ghc-9.8.4 AS builder-9.8

# By installing these separately, we prevent the dependecies of one package from conflicting with the others
RUN cabal update && \
    cabal install --install-method=copy hlint-3.8 && \
    cabal install --install-method=copy fourmolu-0.19.0.1 && \
    cabal install --install-method=copy cabal-fmt-0.1.12

# Copy the built binaries into a smaller image.
FROM fossa/haskell-static-alpine:ghc-9.8.4 AS final

LABEL org.opencontainers.image.source = "https://github.com/fossas/haskell-dev-tools"

COPY --from=builder-9.8 /root/.local/bin/hlint /root/.cabal/bin/hlint
COPY --from=builder-9.8 /root/.local/bin/fourmolu /root/.cabal/bin/fourmolu
COPY --from=builder-9.8 /root/.local/bin/cabal-fmt /root/.cabal/bin/cabal-fmt
