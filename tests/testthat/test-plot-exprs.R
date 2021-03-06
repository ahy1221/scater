## Tests for plotExpression().
## library(scater); library(testthat); source("setup-sce.R"); source("test-plot-exprs.R")

example_sce <- normed

test_that("plotExpression works for various 'x'", {
    for (gene_set in list("Gene_0001", rownames(example_sce)[1:5], 10, 6:20)) { # different numbers of genes, types of specification.
        for (x in list(NULL, "Cell_Cycle", "Gene_0100")) { # nothing, categorical, or continuous.
            expect_s3_class(plotExpression(example_sce, gene_set, x = x), "ggplot")
            expect_s3_class(plotExpression(example_sce, gene_set, x = x, colour_by = "Cell_Cycle"), "ggplot")
            expect_s3_class(plotExpression(example_sce, gene_set, x = x, size_by = "Gene_0001"), "ggplot")
            expect_s3_class(plotExpression(example_sce, gene_set, x = x, shape_by = "Treatment"), "ggplot")
        }
    }
})

test_that("plotExpression works for various aesthetics", {
    gene_set <- rownames(example_sce)[1:20]
    expect_s3_class(plotExpression(example_sce, gene_set, colour_by = "Cell_Cycle", size_by = "Gene_0001"), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, colour_by = "Cell_Cycle", shape_by = "Treatment"), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, size_by = "Gene_0001", shape_by = "Treatment"), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, colour_by = "Cell_Cycle", size_by = "Gene_0001", shape_by = "Treatment"), "ggplot")
    
    expect_s3_class(plotExpression(example_sce, gene_set, size_by = "Gene_0001", shape_by = "Treatment", by_exprs_values = "counts"), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, size_by = "Gene_0001", shape_by = "Treatment", by_show_single = TRUE), "ggplot")

    # Testing options when dealing with many genes and no 'x' specified.
    expect_s3_class(plotExpression(example_sce, gene_set, one_facet=FALSE), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, feature_colours=FALSE), "ggplot")
})

test_that("plotExpression works with semi-analysis options", {
    gene_set <- sample(rownames(example_sce)[5:15])
    expect_s3_class(plotExpression(example_sce, gene_set, show_violin=FALSE), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, show_median=TRUE), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, jitter_type="jitter"), "ggplot")

    expect_s3_class(plotExpression(example_sce, gene_set, x="Gene_0001", show_smooth=TRUE), "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, x="Gene_0001", show_smooth=TRUE, show_se=FALSE), "ggplot")
})

test_that("plotExpression works for different exprs_values", {
    gene_set <- tail(rownames(example_sce))
    expect_s3_class(plotExpression(example_sce, gene_set, x = "Mutation_Status", exprs_values = "counts"),  "ggplot")
    expect_s3_class(plotExpression(example_sce, gene_set, x = "Mutation_Status", exprs_values = "counts", log2_values = TRUE),  "ggplot")
    expect_error(plotExpression(example_sce, rownames(example_sce)[1:6], exprs_values = "silly"), "not in names")

    # And on sparse matrices.        
    sparsified <- example_sce
    logcounts(sparsified) <- as(logcounts(sparsified), "dgCMatrix")
    expect_equal(plotExpression(sparsified, "Gene_0001"), plotExpression(example_sce, "Gene_0001"))
})

test_that("plotExpression works without feature names", {
    dummy <- example_sce
    rownames(dummy) <- NULL
    expect_s3_class(p <- plotExpression(dummy, 1:20),  "ggplot")
    expect_identical(levels(p$data[,1]), sort(sprintf("Feature %i", 1:20)))
})
