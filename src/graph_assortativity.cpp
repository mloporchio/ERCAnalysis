#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <igraph.h>

using namespace std;
using namespace std::chrono;

int main(int argc, char **argv) {
    if (argc < 3) {
        cerr << "Usage: " << argv[0] << " <input_file> <output_file>\n";
        return 1;
    }
    auto start = high_resolution_clock::now();

    // Load the graph from the corresponding file.
    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        cerr << "Error: could not open input file!\n";
        return 1;
    }
    igraph_t graph;
    igraph_read_graph_edgelist(&graph, input_file, 0, 0);
    fclose(input_file);

    // Simplify the graph (removes duplicate edges and self loops).
    igraph_simplify(&graph, 1, 1, NULL);
    igraph_integer_t total_nodes = igraph_vcount(&graph); // This is the number of nodes in the whole graph.

    // Compute the weakly connected components of the graph.
    igraph_integer_t num_wcc;
    igraph_vector_int_t wcc_map;
    igraph_vector_int_t wcc_sizes;
    igraph_vector_int_init(&wcc_map, total_nodes);
    igraph_vector_int_init(&wcc_sizes, total_nodes);
    igraph_connected_components(&graph, &wcc_map, &wcc_sizes, &num_wcc, IGRAPH_WEAK);

    // Extract the subgraph corresponding to the largest connected component.
    igraph_t comp;
    igraph_integer_t largest_comp_id = igraph_vector_int_which_max(&wcc_sizes);
    igraph_integer_t largest_comp_size = VECTOR(wcc_sizes)[largest_comp_id];
    igraph_vector_int_t comp_vertices;
    igraph_vector_int_init(&comp_vertices, largest_comp_size);
    int j = 0;
    for (int i = 0; i < total_nodes; i++) {
        if (VECTOR(wcc_map)[i] == largest_comp_id) {
            VECTOR(comp_vertices)[j] = i;
            j++;
        }
    }   
    igraph_vs_t comp_vids;
    igraph_vs_vector(&comp_vids, &comp_vertices);
    igraph_induced_subgraph(&graph, &comp, comp_vids, IGRAPH_SUBGRAPH_AUTO);

    // Compute the number of nodes and edges in the component.
    igraph_integer_t comp_nodes = igraph_vcount(&comp);
    igraph_integer_t comp_edges = igraph_ecount(&comp);

    // Compute the degree assortativity of the component.
    igraph_real_t assortativity;
    igraph_assortativity_degree(&comp, &assortativity, IGRAPH_UNDIRECTED);
    
    // Compute the degree for each vertex of the component (we treat the graph as undirected).
    igraph_vector_int_t deg_v;
    igraph_vector_int_init(&deg_v, comp_nodes);
    igraph_degree(&comp, &deg_v, igraph_vss_all(), IGRAPH_ALL, 0);
    FILE *output_file = fopen(argv[2], "w");
    if (!output_file) {
        cerr << "Error: could not open output file!\n";
        return 1;
    }
    fprintf(output_file, "node_id,degree\n");
    for (int i = 0; i < comp_nodes; i++) {
        int deg = VECTOR(deg_v)[i];
        fprintf(output_file, "%d,%d\n", i, deg);
    }
    fclose(output_file);

    // Free the memory occupied by the graph.
    igraph_destroy(&graph);
    igraph_destroy(&comp);
    igraph_vector_int_destroy(&wcc_map);
    igraph_vector_int_destroy(&wcc_sizes);
    igraph_vector_int_destroy(&comp_vertices);
    igraph_vector_int_destroy(&deg_v);
    
    auto end = high_resolution_clock::now();
    auto elapsed = duration_cast<nanoseconds>(end - start);
    cout << comp_nodes << '\t' 
        << comp_edges << '\t' 
        << assortativity << '\t'
        << elapsed.count() << '\n';
    return 0;
}


