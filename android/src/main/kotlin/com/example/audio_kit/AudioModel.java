package com.example.audio_kit;
import androidx.annotation.Keep;
@Keep
public class AudioModel {
    String aPath;
    String aName;
    String aAlbum;
    String aArtist;

    String aSize;
    String aDuration;

    public String getaPath() {
        return aPath;
    }
    public void setaPath(String aPath) {
        this.aPath = aPath;
    }
    public String getaName() {
        return aName;
    }
    public void setaName(String aName) {
        this.aName = aName;
    }
    public String getaAlbum() {
        return aAlbum;
    }
    public void setaAlbum(String aAlbum) {
        this.aAlbum = aAlbum;
    }
    public String getaArtist() {
        return aArtist;
    }
    public void setaArtist(String aArtist) {
        this.aArtist = aArtist;
    }

    public String getaSize() {
        return aSize;
    }
    public void setaSize(String aSize) {
        this.aSize = aSize;
    }

    public String getaDuration() {
        return aDuration;
    }
    public void setaDuration(String aDuration) {
        this.aDuration = aDuration;
    }

}