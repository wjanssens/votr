Ext.define('Votr.store.Wards', {
    extend: 'Ext.data.TreeStore',
    root: {
        text: 'All',
        expanded: true,
        children: [
            {text: 'Ward 1', description: 'Description 1', leaf: true, iconCls: 'x-fa fa-home'},
            {
                text: 'Ward 2', description: 'Description 2', leaf: false, children:
                    [
                        {text: 'Ward 21', description: 'Description 21', leaf: true},
                        {text: 'Ward 22', description: 'Description 22', leaf: true},
                    ]
            },
            {text: 'Ward 3', description: 'Description 3', leaf: true},
            {text: 'Ward 4', description: 'Description 4', leaf: true}
        ]
    }
});
