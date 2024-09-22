import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/utility/firebase_utility.dart';
import 'package:task_management/network/data/header_loading_provider.dart';
import 'package:task_management/network/data/notes/notes_provider.dart';
import 'package:task_management/network/data/sync_provider.dart';
import 'package:task_management/network/models/header_message_model.dart';
import 'package:task_management/widgets/homeScreenWidget/header_message_widget.dart';

import '../models/NoteModel.dart';

class HeaderMessageProvider with ChangeNotifier {
  HeaderMessageModel? _headerMessage;

  HeaderMessageModel? get headerMessage {
    return _headerMessage;
  }

  Future<void> uploadNoteToFireStore(List<NoteModel> notesToUpload, BuildContext context) async {
    Map<String, dynamic> userDetails = context.read<NotesProvider>().userDetails;
    context.read<HeaderLoadingProvider>().updateIsLoading(true);
    for(NoteModel note in notesToUpload) {
      await FirebaseUtility.submitNoteToFirebase(null, note, userDetails, context);
    }
    context.read<HeaderLoadingProvider>().updateIsLoading(false);
    context.read<SyncProvider>().updateSyncStatus(SyncStatus.synced);
    dismissTheHeaderMessage();
    context.read<NotesProvider>().fetchRemoteNotes(context);
  }

  void dismissTheHeaderMessage() {
    _headerMessage = null;
    notifyListeners();
  }

  Future<void> fetchNoteFromFireStore(BuildContext context) async {
    await context.read<NotesProvider>().addExclusiveFetchedNotesToHive();
    context.read<SyncProvider>().updateSyncStatus(SyncStatus.synced);
    dismissTheHeaderMessage();
  }

  Future<void> uploadThenFetchNoteToFireStore(BuildContext context, List<NoteModel> notesToUpload) async {
    Map<String, dynamic> userDetails = context.read<NotesProvider>().userDetails;
    context.read<HeaderLoadingProvider>().updateIsLoading(true);
    for(NoteModel note in notesToUpload) {
      await FirebaseUtility.submitNoteToFirebase(null, note, userDetails, context);
    }
    context.read<HeaderLoadingProvider>().updateIsLoading(false);
    await fetchNoteFromFireStore(context);

  }

  void buildHeaderMessageFromExclusiveList(List<NoteModel> exclusiveLocalNotes, List<NoteModel> exclusiveFetchedNotes, BuildContext context) {

    if(exclusiveLocalNotes.isNotEmpty && exclusiveFetchedNotes.isNotEmpty) {
      var model = HeaderMessageModel(message: 'Notes are not Synced', messageStatus: HeaderMessageStatus.warning, callback: () => uploadThenFetchNoteToFireStore(context, exclusiveLocalNotes), callbackText: 'Sync');
      showHeaderMessage(model);
    } else if (exclusiveLocalNotes.isNotEmpty) {
      var model = HeaderMessageModel(message: 'Notes are not Synced', messageStatus: HeaderMessageStatus.warning, callback: () => uploadNoteToFireStore(exclusiveLocalNotes, context), callbackText: 'Sync');
      showHeaderMessage(model);
    } else if (exclusiveFetchedNotes.isNotEmpty) {
      var model = HeaderMessageModel(message: "${exclusiveFetchedNotes.length} new Notes are available.", messageStatus: HeaderMessageStatus.warning, callback: () => fetchNoteFromFireStore(context), callbackText: 'load');
      showHeaderMessage(model);
    } else {
      throw Exception('Error : buildHeaderMessageFromExclusiveList in header message provider : exclusive notes are might be empty but still header message was called');
    }
  }


  void buildHeaderMessageFromError(String errorMessage) {
    var model = HeaderMessageModel(message: errorMessage, messageStatus: HeaderMessageStatus.error);
    showHeaderMessage(model);
  }


  void buildHeaderMessageFromSuccess(String successMessage) {
    var model = HeaderMessageModel(message: successMessage, messageStatus: HeaderMessageStatus.success);
    showHeaderMessage(model);
  }


  showHeaderMessage(HeaderMessageModel headerMessageToShow) {
    _headerMessage = headerMessageToShow;
    notifyListeners();
  }
}