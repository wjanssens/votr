Ext.define('Votr.store.Wards', {
    extend: 'Ext.data.TreeStore',
    model: 'Votr.model.Ward',
    root: {
        text: 'All',
        expanded: true,
        children: [
            {name: { default: 'Ward 1' }, description: { default: 'Description 1' }, leaf: true},
            {
                name: { default: 'Ward 2' }, description: { default: 'Description 2' }, leaf: false, children:
                    [
                        {name: { default: 'Ward 21' }, description: { default: 'Description 21' }, leaf: true},
                        {name: { default: 'Ward 22' }, description: { default: 'Description 22' }, leaf: true},
                    ]
            },
            {name: { default: 'Ward 3' }, description: { default: 'Description 3' }, leaf: true},
            {name: { default: 'Ward 4' }, description: { default: 'Description 4' }, leaf: true}
        ]
    }
});
