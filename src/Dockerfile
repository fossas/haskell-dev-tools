# Build all tools except cabal-fmt and packdeps.
FROM fossa/haskell-static-alpine:ghc-9.0.2 as builder-9.0

RUN cabal update && cabal install --install-method=copy \
  hlint-3.4.1 \
  fourmolu-0.8.2.0 \
  prune-juice-0.7 \
  hadolint-2.11.0

# cabal-fmt and packdeps only build on GHC 8.10, but still work for projects
# using GHC 9.
FROM fossa/haskell-static-alpine:ghc-8.10.7 as builder-8.10

RUN cabal update && cabal install --install-method=copy \
  cabal-fmt-0.1.5.1 \
  packdeps-0.6.0.0

# Copy the built binaries into a smaller image.
FROM fossa/haskell-static-alpine:ghc-9.0.2 as final

# Install rust toolchain
RUN mkdir -p ~/.cargo/bin && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile=minimal -y --default-toolchain 1.63.0
ENV PATH="/root/.cargo/bin:$PATH"
RUN rustup component add rustfmt && rustup component add clippy

LABEL org.opencontainers.image.source = "https://github.com/fossas/haskell-dev-tools"

COPY --from=builder-9.0 /root/.cabal/bin/hlint /root/.cabal/bin/hlint
COPY --from=builder-9.0 /root/.cabal/bin/fourmolu /root/.cabal/bin/fourmolu
COPY --from=builder-9.0 /root/.cabal/bin/prune-juice /root/.cabal/bin/prune-juice
COPY --from=builder-9.0 /root/.cabal/bin/hadolint /root/.cabal/bin/hadolint
COPY --from=builder-8.10 /root/.cabal/bin/cabal-fmt /root/.cabal/bin/cabal-fmt
COPY --from=builder-8.10 /root/.cabal/bin/packdeps /root/.cabal/bin/packdeps
