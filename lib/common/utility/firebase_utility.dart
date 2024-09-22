import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../network/data/header_message_provider.dart';
import '../../network/data/notes/notes_provider.dart';
import '../../network/data/sync_provider.dart';
import '../../network/models/NoteModel.dart';



class FirebaseUtility {
  static Future<void> deleteMapFromFireStoreIfExists(String userEmail, Map<String, dynamic> mapToRemove, BuildContext context) async {
  print('delete map from firestore called');
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('userNotes');

      // Get the document's current data
      DocumentSnapshot snapshot = await collection.doc(userEmail).get();

      if (snapshot.exists) {
        // Access the current list of maps from 'notes'
        List<dynamic> notes = snapshot['notes'] as List<dynamic>;

        Set<String> notesIds = notes.map((note) => (note as Map<String, dynamic>)['id'] as String).toSet();



        // Check if the mapToRemove exists in the list
        if (notesIds.any((id) => id == mapToRemove['id'])) {
          // print('id does exists when deleting a map from firestore');
          // print('map to delete : $mapToRemove');
          // for(var note in notes) {
          //   print('from firestore : $note');
          // }
          // Use FieldValue.arrayRemove to remove the map
          await collection.doc(userEmail).update({
            'notes': FieldValue.arrayRemove([mapToRemove])
          });
        }
      }
    } on FirebaseException catch (e) {
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError(e.message ?? 'Could not delete note from Cloud, error code : ${e.code}');
      context.read<SyncProvider>().updateSyncStatus(SyncStatus.notSynced);
    } on SocketException catch(e) {
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError('Check your Internet connection.');
      context.read<SyncProvider>().updateSyncStatus(SyncStatus.notSynced);
    }


  }

  static Future<void> addMapToFireStore(String userEmail, Map<String, dynamic> mapToAdd, BuildContext context) async {

    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('userNotes');

      // Get the document's current data (optional, just to check if document exists)
      DocumentSnapshot snapshot = await collection.doc(userEmail).get();

      if (snapshot.exists) {
        // Use FieldValue.arrayUnion to add the map
        await collection.doc(userEmail).update({
          'notes': FieldValue.arrayUnion([mapToAdd])
        });
      } else {
        // If the document doesn't exist, you can create it with the map
        await collection.doc(userEmail).set({
          'notes': [mapToAdd]
        });
      }
    } on FirebaseException catch (e) {
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError(e.message ?? 'Could not add note to Cloud, error code : ${e.code}');
      context.read<SyncProvider>().updateSyncStatus(SyncStatus.notSynced);
    } on SocketException catch(_) {
      print('socket error');
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError('Check your Internet connection.');
      context.read<SyncProvider>().updateSyncStatus(SyncStatus.notSynced);
    }

  }

  static Future<void> submitNoteToFirebase(NoteModel? oldNote, NoteModel note, Map<String, dynamic> userDetails, BuildContext context) async {


    if(userDetails['isSynced'] == false) {
      return;
    }

      String userEmail = userDetails['email'];


      if(oldNote != null) {
        Map<String, dynamic> oldNoteMap = context.read<NotesProvider>().getMapFromNoteModel(oldNote);
        await deleteMapFromFireStoreIfExists(userEmail, oldNoteMap, context);
      }

      Map<String, dynamic> newNoteMap = context.read<NotesProvider>().getMapFromNoteModel(note);
      await addMapToFireStore(userEmail, newNoteMap, context);





  }
}