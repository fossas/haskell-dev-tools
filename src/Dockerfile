# Build all tools except hadolint.
FROM fossa/haskell-static-alpine:ghc-9.4.7 as builder-9.4

# By installing these separately, we prevent the dependecies of one package from conflicting with the others
RUN cabal update && \
    cabal install --install-method=copy hlint-3.6.1 && \
    cabal install --install-method=copy fourmolu-0.13.1.0 && \
    cabal install --install-method=copy cabal-fmt-0.1.7

FROM fossa/haskell-static-alpine:ghc-9.0.2 as builder-9.0

RUN cabal update && \
    cabal install --install-method=copy hadolint-2.11.0

# Copy the built binaries into a smaller image.
FROM fossa/haskell-static-alpine:ghc-9.4.7 as final

LABEL org.opencontainers.image.source = "https://github.com/fossas/haskell-dev-tools"

COPY --from=builder-9.4 /root/.local/bin/hlint /root/.cabal/bin/hlint
COPY --from=builder-9.4 /root/.local/bin/fourmolu /root/.cabal/bin/fourmolu
COPY --from=builder-9.4 /root/.local/bin/cabal-fmt /root/.cabal/bin/cabal-fmt
COPY --from=builder-9.0 /root/.cabal/bin/hadolint /root/.cabal/bin/hadolint
