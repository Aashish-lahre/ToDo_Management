import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notes/notes_provider.dart';

enum SyncStatus {
  notSynced, syncFalse, syncTrue, synced;

  static SyncStatus evaluateSyncStatus(bool isSynced) {
    if(isSynced == false) return SyncStatus.syncFalse;
    return SyncStatus.syncTrue;
  }
}

class SyncProvider with ChangeNotifier {
  bool _isSynced = false;
   SyncStatus _syncStatus = SyncStatus.syncFalse;



  SyncStatus get syncStatus {

    return _syncStatus;
  }
  bool get isSynced => _isSynced;

  void updateIsSynced(bool isSynced) {
    // print('update is synced');
    _isSynced = isSynced;
    if(_syncStatus == SyncStatus.syncFalse || _syncStatus == SyncStatus.syncTrue || _isSynced == false) {
      _syncStatus = SyncStatus.evaluateSyncStatus(isSynced);

    }
    notifyListeners();
  }


  void updateSyncStatus(SyncStatus status) {
    assert(_isSynced == true, "Error: isSynced in updateSyncStatus in SyncProvider is false");
    _syncStatus = status;
    notifyListeners();
  }


  Future<void> updateSyncInFirestore(BuildContext context) async {
    print('called : update sync in firestore');
    Map<String, Object> userNotes = await Provider.of<NotesProvider>(context, listen: false).fetchUserNotes();

    if(userNotes['type'] == 'guest') {
      return;
    }


    try {
      String userEmail = (userNotes['userDetails'] as Map)['email'];
      bool userIsSynced = (userNotes['userDetails'] as Map)['isSynced'];

      CollectionReference collection = FirebaseFirestore.instance.collection('userNotes');

      // Get the document's current data (optional, just to check if document exists)
      DocumentSnapshot snapshot = await collection.doc(userEmail).get();

      if (snapshot.exists) {
        // Use FieldValue.arrayUnion to add the map
        await collection.doc(userEmail).update({
          'isSynced': userIsSynced
        });
        print('sync is updated in firestore');
      } else {
        throw Exception('Error : userNotes document with email : $userEmail do not exists, but it should');
      }


    } on FirebaseException catch(e) {
throw Exception('error in updating isSynced in firestore : $e');
    } on SocketException catch(e) {
    } on TimeoutException catch(e) {
    }


  }




}