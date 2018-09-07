Ext.define('Votr.view.voter.Main', {
    extend: 'Ext.Panel',
    alias: 'widget.voter.main',
    requires: [
        "Votr.view.voter.MainController"
    ],
    controller: 'voter.main',
    scrollable: true,
    layout: 'hbox',
    items: [{
        xtype: 'panel',
        flex: 1,
    }, {
        xtype: 'voter.ballots',
        itemId: 'ballots',
        width: 512
    }, {
        xtype: 'panel',
        flex: 1,
    }]
});