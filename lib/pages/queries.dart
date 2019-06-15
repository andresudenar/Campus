String getQueryElementsFolder (final List path){
  String query = 'query{__type(name:"' +path[path.length-1]+ 'Elements"){fields{name type{name ofType{name}}}}}';
  print ("Aquí estamos creando la consulta de los tipos" + query);
  return query;
}

String getQueryInfoElementsFolder(final List path, elements){//información de los folders
  String query = 'query{type}';
  String pathElement;

  for (int i = 0; i < path.length; i++) {
    pathElement = path[i] + '{elements{type}}';
    query = query.replaceAll('type', pathElement);
  }

  for(int i=0;i<elements.length;i++){
    pathElement = elements[i]['name'] + '{title icon state theme description} type';
    query = query.replaceAll('type', pathElement);
  }

  query = query.replaceAll('type', "");
  print ("Esta es la consulta generada"+query);
  return query;
}