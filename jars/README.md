# jars

Part of the code used for the analysis was written in Java. This folder contains a set of JAR files used for several tasks. In particular:

1. <code>ContractCreator.jar</code> reads a list of ERC-20 or ERC-721 Transfer events and divides them based on the triggering contracts, creating an output file for each contract.
2. <code>PathAnalyzer.jar</code> uses the [WebGraph](https://webgraph.di.unimi.it/docs/index.html) library to analyze the average shortest path length and diameter of an input transfer event graph.
3. <code>WebgraphBuilder.jar</code> reads a list of edges and builds the corresponding transfer event graph according to the [BVGraph](https://webgraph.di.unimi.it/docs/it/unimi/dsi/webgraph/BVGraph.html) format used by WebGraph.