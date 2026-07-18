function onNoteCreation(ev) {
    if (event.noteType != null && event.noteType != "")
        return;
    ev.cancel();
    if (ev.note.isSustainNote) {
        ev.note.loadGraphic(Paths.image('notes/HummerArrows_cont'), true, 10, 4);
        ev.note.animation.add("hold", [ev.strumID]);
        ev.note.animation.add("holdend", [ev.strumID + 4]);
        ev.note.scale.set(5, 5);
    } else {
        ev.note.loadGraphic(Paths.image('notes/HummerArrows'), true, 24, 24);
        ev.note.animation.add("scroll", [ev.strumID + 20]);
        ev.note.scale.set(5, 5);
        ev.note.updateHitbox();
    }
    ev.note.updateHitbox();
}

function onStrumCreation(ev) {
    ev.cancel();
    ev.strum.loadGraphic(Paths.image('notes/HummerArrows'), true, 24, 24);
    ev.strum.scale.set(5, 5);
    ev.strum.updateHitbox();
    ev.strum.animation.add("static", [ev.strumID]);
    ev.strum.animation.add("pressed", [4 + ev.strumID, 8 + ev.strumID], 24, false);
    ev.strum.animation.add("confirm", [12 + ev.strumID, 16 + ev.strumID], 24, false);
}

function onPlayerHit(e)
{
    e.note.splash = "hummerNoteSplash";
}