#!/bin/bash

set -eu

tmpdir=$(mktemp -d)
ln -s `pwd`/$1 $tmpdir/
cd $tmpdir

cat <<EOD > jsarticle.tplx
% Default to the notebook output style
((* if not cell_style is defined *))
    ((* set cell_style = 'style_ipython.tplx' *))
((* endif *))

% Inherit from the specified cell style.
((* extends cell_style *))

%===============================================================================
% Latex Article
%===============================================================================

((* block docclass *))
\documentclass[a4paper,dvipdfmx]{jsarticle}
((* endblock docclass *))
EOD

FILENAME=$(basename $1 .ipynb)
jupyter nbconvert --to latex --template jsarticle.tplx $1
extractbb ${FILENAME}_files/*.png
platex ${FILENAME}.tex
dvipdfmx ${FILENAME}.dvi

cd -
cp $tmpdir/${FILENAME}.pdf .
