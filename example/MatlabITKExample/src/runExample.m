
% read medical image
[image, origin, spacing] = readmedicalimage_gateway('jakob_stripped_onlyGM_orderedlabels_DS.hdr') ;
imagesc(image(:,:,50))

% write medical image
writemedicalimage_gateway('test.hdr',image,origin,spacing,'uint8')
display('compare test.img/hdr with jakob_stripped_onlyGM_orderedlabels_DS.img/hdr to make sure everything is correct ....')
