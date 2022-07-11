# Build the correct binaries
FROM fossa/haskell-static-alpine:ghc-9.0.2 as builder-9.0
LABEL org.opencontainers.image.source = "https://github.com/fossas/haskell-dev-tools"
RUN cabal update && cabal install hlint-3.4.1 && cabal install fourmolu-0.7.0.1 
# Replace symlinks with their actual files so we can slim down the image later
RUN cp "$(readlink -f "$(which hlint)")" "$(readlink -f "$(which fourmolu)")" /root/.cabal/bin/

# cabal-fmt doesn't build for ghc-9.0 yet, so we do a little sneaky.
# The build from the previous GHC just works, so we use the old one.
# hlint and fourmolu are very tightly coupled with GHC versions, but not cabal-fmt.
FROM fossa/haskell-static-alpine:ghc-8.10.7 as builder-8.10
RUN cabal update && cabal install cabal-fmt-0.1.5.1
# Do the symlink-slim
RUN cp "$(readlink -f "$(which cabal-fmt)")" /root/.cabal/bin/

# Copy the binaries into a smaller image
FROM fossa/haskell-static-alpine:ghc-9.0.2 as final
COPY --from=builder-9.0 /root/.cabal/bin/hlint /root/.cabal/bin/hlint
COPY --from=builder-9.0 /root/.cabal/bin/fourmolu /root/.cabal/bin/fourmolu
COPY --from=builder-8.10 /root/.cabal/bin/cabal-fmt /root/.cabal/bin/cabal-fmt
