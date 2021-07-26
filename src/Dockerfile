# Build the correct binaries
FROM fossa/haskell-static-alpine:ghc-8.10.4 as builder
LABEL org.opencontainers.image.source = "https://github.com/fossas/haskell-dev-tools"
RUN cabal update && cabal install hlint-3.3.1 && cabal install fourmolu-0.3.0.0
# Replace symlinks with their actual files so we can slim down the image
RUN cp "$(readlink -f "$(which hlint)")" "$(readlink -f "$(which fourmolu)")" /root/.cabal/bin/

# Copy the binaries into a smaller image
FROM fossa/haskell-static-alpine:ghc-8.10.4 as final
COPY --from=builder /root/.cabal/bin/hlint /root/.cabal/bin/hlint
COPY --from=builder /root/.cabal/bin/fourmolu /root/.cabal/bin/fourmolu
RUN echo cachebust