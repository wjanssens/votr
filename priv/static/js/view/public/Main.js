Ext.define('Votr.view.public.Main', {
    extend: 'Ext.Container',
    alias: 'widget.public.main',
    requires: [
        "Votr.view.public.MainController"
    ],
    controller: 'public.main',
    scrollable: true,
    layout: 'hbox',
    padding: 0,
    style: 'background: #f5f5fa;',
    items: [{
        xtype: 'container',
        flex: 1,
    }, {
        xtype: 'container',
        layout: 'card',
        itemId: 'cards',
        padding: 0,
        shadow: true,
        items: [
            {
                xtype: 'public.ballots',
            },
            {
                xtype: 'public.ballot',
            }
        ],
        plugins: 'responsive',
        responsiveConfig: {
            'width < 512': {
                width: '100%'
            },
            'width >= 512': {
                width: 512
            },
        }
    }, {
        xtype: 'container',
        flex: 1,
    }]
});