Dockeritzador de projectes TBP

S'afegeix com una subcarpeta al projecte TBP mitjançant *git submodule*.

Cal que els Dockerfiles tinguin com a context l'arrel del projecte que dockeritzen, tanmateix a l'estructura GIT el Dockerfile i els seus fitxers associats son a una subcarpeta.

Hi han dues solucions per al problema:

La solució Linux és linkar el fitxer Dockerfile de la carpeta web-server a l'arrel del projecte.

La solució Docker és indicar mitjançant el paràmetre *context* on és l'arrel del projecte al fer *build*.

