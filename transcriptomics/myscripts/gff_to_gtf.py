#!/usr/bin/env python3
"""
Convert a GFF file to a minimal GTF suitable for featureCounts.
Only keeps exon features, and assigns gene_id and transcript_id
from the attributes in the GFF.
"""

import sys

gff_file = "Crys.gff"
gtf_file = "Crys_exon_minimal.gtf"

with open(gff_file) as gff, open(gtf_file, "w") as gtf:
    for line in gff:
        if line.startswith("#"):
            continue
        fields = line.strip().split("\t")
        if len(fields) < 9:
            continue
        seqid, source, ftype, start, end, score, strand, phase, attrs = fields

        # Only keep exons (or CDS if exons not present)
        if ftype.lower() not in ["exon", "cds"]:
            continue

        # Parse attributes: look for ID or Name for gene_id / transcript_id
        attr_dict = {}
        for attr in attrs.split(";"):
            if "=" in attr:
                key, value = attr.strip().split("=", 1)
                attr_dict[key] = value

        gene_id = attr_dict.get("gene", attr_dict.get("ID", "gene0"))
        transcript_id = attr_dict.get("transcript", gene_id)

        # write minimal GTF
        gtf.write(
            f"{seqid}\t{source}\t{ftype}\t{start}\t{end}\t{score}\t{strand}\t{phase}\tgene_id \"{gene_id}\"; transcript_id \"{transcript_id}\";\n"
        )

print(f"Minimal GTF written to {gtf_file}")
