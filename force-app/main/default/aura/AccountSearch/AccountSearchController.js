({
    onInit: function( component, event, helper ) {
        // proactively search on component initialization
        var searchTerm = component.get( "v.searchTerm" );
        helper.handleSearch( component, searchTerm );
    },
    onSearchTermChange: function( component, event, helper ) {
        // search anytime the term changes in the input field
        var searchTerm = component.get( "v.searchTerm" );
        helper.handleSearch( component, searchTerm );
    }
})