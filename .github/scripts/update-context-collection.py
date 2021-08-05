import strax
import straxen
import cutax
from cutax.contexts import __all__ as context_list
from utilix import DB
import datetime


db = DB()


def main():
    for context in context_list:
        # pass cuts_for=None so that we don't track the cut lineages. They aren't saved anyway
        st = getattr(cutax.contexts, context)(cuts_for=None)
        hash_dict = {dtype: dtype_info['hash'] for dtype, dtype_info in st.provided_dtypes().items()}

        doc = dict(name=context,
                   date_added=datetime.datetime.utcnow(),
                   hashes=hash_dict,
                   straxen_version=straxen.__version__,
                   strax_version=strax.__version__,
                   cutax_version=cutax.__version__
                   )

        # update the context collection using utilix + runDB_api
        db.update_context_collection(doc)

if __name__ == "__main__":
    main()
