/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1

XmlListModel {
    id: model

    property bool loading: status == XmlListModel.Loading
    property string channelName: "nokiadevforum"
    property string channelNameUserReadable: "Nokia Developer"
    property string orderBy: "published"
    property string searchTerm: ""
    property int startIndex: 1
    property int maxResults: 20

    signal modelReady
    signal modelError

    source: "http://gdata.youtube.com/feeds/mobile/videos?" +
            "q=" + model.searchTerm +
            "&author=" + model.channelName +
            "&start-index=" + model.startIndex +
            "&orderby=" + model.orderBy +
            "&v=2"
    // Max result count currently omitted. Uncomment to re-enable.
//            "&max-results=" + model.maxResults +


    namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';
                            declare namespace media = 'http://search.yahoo.com/mrss/';
                            declare namespace openSearch = 'http://a9.com/-/spec/opensearch/1.1/';
                            declare namespace gd = 'http://schemas.google.com/g/2005';
                            declare namespace yt = 'http://gdata.youtube.com/schemas/2007';"

    query: "/feed/entry"
    XmlRole {
        name: "m_title";
        query: "media:group/media:title/string()"

    }
    XmlRole {
        name: "m_contentUrl";
        query: "media:group/media:content[1]/@url/string()"
    }
    XmlRole {
        name: "m_thumbnailUrl";
        query: "media:group/media:thumbnail[1]/@url/string()"
    }
    XmlRole {
        name: "m_duration"; // In seconds
        query: "media:group/media:content[1]/@duration/string()"
    }
    XmlRole {
        name: "m_viewCount";
        query: "yt:statistics/@viewCount/string()"
    }
    XmlRole {
        name: "m_numDislikes";
        query: "yt:rating/@numDislikes/string()"
    }
    XmlRole {
        name: "m_numLikes";
        query: "yt:rating/@numLikes/string()"
    }
    XmlRole {
        name: "m_author";
        query: "author/name/string()"
    }
    XmlRole {
        name: "m_description";
        query: "media:group/media:description[1]/string()"
    }
    XmlRole {
        name: "m_uploaded";
        query: "media:group/yt:uploaded/string()"
    }

    onStatusChanged: {
        if (status === XmlListModel.Ready) {
            modelReady();
        } else if (status === XmlListModel.Error) {
            console.log("Error in XmlListModel: " + errorString());
            modelError();
        }
    }
}
