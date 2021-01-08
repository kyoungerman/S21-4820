//assuming you have a table with an ID of src_table
var my_svg = '<svg xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" id="svg_table" width="'+$("#src_table").width()+'px" height="'+$("#src_table").height()+'px">'
var table_offset = $('#src_table').offset();
$('#src_table').find('td').each(function() {
        //Add a rectangle for each <td> in the same place in SVG as the <td> is in relation to the top left of where the table is on page
        my_svg += '<rect x="'+(this_offset.left - table_offset.left)+'" y="'+(this_offset.top - table_offset.top)+'" width="'+$(this).width()+'" height="'+$(this).height()+'" stroke="black" stroke-width="'+$(this).css('border-width').replace('px','')+'"/>';

       //Text is assumed to be in a <p> tag. If it's not, just use the .html() of the <td> element
       (this).children('p').each(function(){
                t_offset = $(this).offset();
                var this_text = '<text x="'+(t_offset.left - table_offset.left)+'" y="'+(t_offset.top - table_offset.top)+'"  style="font-size:'+$(this).css('font-size')+'; fill: #ffffff">';
                    // Look for <br> tags and split them onto new lines.
                    var this_lines = $(this).html().split('<br>');
                    for(var i=0;i<this_lines.length;i++){
                        this_text += '<tspan x="'+(t_offset.left - table_offset.left)+'" dy="'+$(this).css('font-size')+'">'+this_lines[i]+'</tspan>';
                    }
            this_text += '</text>';
            my_svg +=  this_text;
        })
    }
});
my_svg += '</svg>';

//Either append my_svg to a div or pass the code onto whatever else you need to do with it.
