Ext.define('Votr.view.voter.RankField', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.rankfield',
    layout: 'hbox',
    data: { rank: 0, max: 0, ranked: true },
    setData: function(data) {
        this.callParent(arguments);
        this.down('#value').setData(data);
    },
    getMax: function() {
        return this.getData().max;
    },
    getRank: function() {
        return this.getData().rank;
    },
    setRank: function(rank) {
        var data = this.getData();
        if (rank >= 0 && (data.max == null || rank <= data.max)) {
            var oldValue = data.rank;
            data.rank = rank;
            this.setData(data);
            this.fireEvent('rank', rank, oldValue);
        }
    },
    increment: function() {
        var data = this.getData();
        this.setRank(data.rank + 1);
    },
    decrement: function() {
        var data = this.getData();
        this.setRank(data.rank - 1);
    },
    items: [{
        xtype: 'button',
        iconCls: 'x-fa fa-minus',
        ui: 'action',
        width: 48,
        handler: function() { this.up().decrement(); }
    },{
        xtype: 'component',
        itemId: 'value',
        tpl: new Ext.XTemplate(
            '<tpl for=".">',
                '<tpl if="rank == 0"><p>&mdash;</p></tpl>',
                '<tpl if="ranked && rank &gt; 0"><p>{rank}</p></tpl>',
                '<tpl if="!ranked && rank &gt; 0"><p>&check;</p></tpl>',
            '</tpl>'
        ),
        style: 'font-size: 1.5em; text-align: center; margin-top: 16px;',
        styleHtmlContent: true,
        readOnly: true,
        width: 32
    },{
        xtype: 'button',
        iconCls: 'x-fa fa-plus',
        ui: 'action',
        width: 48,
        handler: function() { this.up().increment(); }
    }]
});