# Build all tools except cabal-fmt and packdeps.
FROM fossa/haskell-static-alpine:ghc-9.0.2 as builder-9.0

# By installing these separately, we prevent the dependecies of one package from conflicting with the others
RUN cabal update && \
    cabal install --install-method=copy hlint-3.5 && \
    cabal install --install-method=copy fourmolu-0.10.1.0 && \
    cabal install --install-method=copy prune-juice-0.7 && \
    cabal install --install-method=copy hadolint-2.12.0

# cabal-fmt and packdeps only build on GHC 8.10, but still work for projects
# using GHC 9.
FROM fossa/haskell-static-alpine:ghc-8.10.7 as builder-8.10

# By installing these separately, we prevent the dependecies of one package from conflicting with the others
RUN cabal update && \
    cabal install --install-method=copy cabal-fmt-0.1.6 && \
    cabal install --install-method=copy packdeps-0.6.0.0

# Copy the built binaries into a smaller image.
FROM fossa/haskell-static-alpine:ghc-9.0.2 as final

LABEL org.opencontainers.image.source = "https://github.com/fossas/haskell-dev-tools"

COPY --from=builder-9.0 /root/.cabal/bin/hlint /root/.cabal/bin/hlint
COPY --from=builder-9.0 /root/.cabal/bin/fourmolu /root/.cabal/bin/fourmolu
COPY --from=builder-9.0 /root/.cabal/bin/prune-juice /root/.cabal/bin/prune-juice
COPY --from=builder-9.0 /root/.cabal/bin/hadolint /root/.cabal/bin/hadolint
COPY --from=builder-8.10 /root/.cabal/bin/cabal-fmt /root/.cabal/bin/cabal-fmt
COPY --from=builder-8.10 /root/.cabal/bin/packdeps /root/.cabal/bin/packdeps
