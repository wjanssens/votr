Ext.define('Votr.view.voter.Main', {
    extend: 'Ext.Panel',
    alias: 'widget.voter.main',
    requires: [
        "Votr.view.voter.MainController"
    ],
    controller: 'voter.main',
    scrollable: true,
    layout: 'hbox',
    padding: 0,
    items: [{
        xtype: 'panel',
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
        xtype: 'panel',
        flex: 1,
    }]
});