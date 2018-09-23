Ext.define('Votr.view.voter.Main', {
    extend: 'Ext.Container',
    alias: 'widget.voter.main',
    requires: [
        "Votr.view.voter.MainController"
    ],
    controller: 'voter.main',
    scrollable: true,
    layout: 'hbox',
    padding: 0,
    style: 'background: #f5f5fa;',
    items: [{
        xtype: 'container',
        flex: 1,
    }, {
        xtype: 'voter.ballots',
        itemId: 'ballots',
        padding: 0,
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