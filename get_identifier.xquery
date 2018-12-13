declare namespace mods = "http://www.loc.gov/mods/v3";

for $mods in collection('file:///g:/ldl/lsu-music/troubleshooting/')
    let $identifier := $mods//mods:identifier[@displayLabel='Call Number']/text()
    order by $identifier
return concat('&#xa;',$identifier)